import "dotenv/config";
import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import rateLimit from "express-rate-limit";
import jwt from "jsonwebtoken";
import { z } from "zod";

const app = express();
const port = Number(process.env.PORT || 4000);
const jwtSecret = process.env.JWT_SECRET || "change_me";
const freeDailyLimit = Number(process.env.FREE_DAILY_LIMIT || 20);

app.use(helmet());
app.use(cors({ origin: true }));
app.use(express.json({ limit: "32kb" }));
app.use(morgan("combined"));

const limiter = rateLimit({
  windowMs: 60 * 1000,
  max: 60,
  standardHeaders: true,
  legacyHeaders: false
});

app.use(limiter);

const usageStore = new Map();

const authSchema = z.object({
  email: z.string().email().optional(),
  deviceId: z.string().min(6)
});

const translateSchema = z.object({
  text: z.string().min(1).max(2000),
  sourceLang: z.string().min(2).max(10).optional(),
  targetLangs: z.array(z.string().min(2).max(10)).min(1)
});

function signToken(payload) {
  return jwt.sign(payload, jwtSecret, { expiresIn: "7d" });
}

function authMiddleware(req, res, next) {
  const header = req.headers.authorization || "";
  const token = header.startsWith("Bearer ") ? header.slice(7) : null;
  if (!token) {
    return res.status(401).json({ error: "Missing token" });
  }
  try {
    req.user = jwt.verify(token, jwtSecret);
    return next();
  } catch (error) {
    return res.status(401).json({ error: "Invalid token" });
  }
}

function getUsageKey(user) {
  const day = new Date().toISOString().slice(0, 10);
  return `${user.sub}:${day}`;
}

function ensureUsageEntry(key) {
  if (!usageStore.has(key)) {
    usageStore.set(key, { count: 0 });
  }
  return usageStore.get(key);
}

async function translateWithGemini({ text, sourceLang, targetLangs }) {
  if (!process.env.GEMINI_API_KEY) {
    return targetLangs.map((lang) => ({
      lang,
      text: `[DEMO ${lang}] ${text}`
    }));
  }
  // Placeholder: integrar com Gemini API
  return targetLangs.map((lang) => ({
    lang,
    text: `[TODO ${lang}] ${text}`
  }));
}

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

app.post("/v1/auth/anonymous", (req, res) => {
  const parsed = authSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: "Invalid payload" });
  }
  const subject = parsed.data.email || parsed.data.deviceId;
  const token = signToken({ sub: subject, plan: "free" });
  return res.json({ token, plan: "free", limit: freeDailyLimit });
});

app.post("/v1/translate", authMiddleware, async (req, res) => {
  const parsed = translateSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: "Invalid payload" });
  }

  const usageKey = getUsageKey(req.user);
  const usage = ensureUsageEntry(usageKey);

  if (req.user.plan === "free" && usage.count >= freeDailyLimit) {
    return res.status(402).json({ error: "Free limit reached" });
  }

  usage.count += 1;

  try {
    const translations = await translateWithGemini(parsed.data);
    return res.json({
      translations,
      usage: {
        count: usage.count,
        limit: req.user.plan === "free" ? freeDailyLimit : null
      }
    });
  } catch (error) {
    return res.status(500).json({ error: "Translation failed" });
  }
});

app.listen(port, () => {
  // eslint-disable-next-line no-console
  console.log(`Backend listening on ${port}`);
});
