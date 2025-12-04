import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const json = (status: number, body: Record<string, unknown>) =>
  new Response(JSON.stringify(body), { status, headers: { "content-type": "application/json" } });

function normalizePhone(phone: string): string {
  return phone.trim().replace(/[\s-]/g, "");
}

async function findUserByPhone(supabase: any, phone: string) {
  let page = 1;
  const perPage = 200;
  while (true) {
    const { data, error } = await supabase.auth.admin.listUsers({ page, perPage });
    if (error) return undefined;
    const users = data?.users ?? [];
    const found = users.find(
      (u: any) =>
        (typeof u.phone === "string" && normalizePhone(u.phone) === phone) ||
        (typeof u.user_metadata?.phone === "string" && normalizePhone(u.user_metadata.phone) === phone)
    );
    if (found) return found;
    if (users.length < perPage) return undefined;
    page++;
  }
}

serve(async (req) => {
  try {
    const url = Deno.env.get("SUPABASE_URL")!;
    const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(url, key);
    const body = await req.json();
    const rawPhone = String(body?.phone ?? "");
    const password = String(body?.password ?? "");
    const phone = normalizePhone(rawPhone);
    if (!phone || phone.length < 6) return json(400, { code: 400, message: "手机号不合法" });
    const exists = await findUserByPhone(supabase, phone);
    if (exists) return json(409, { code: 409, message: "用户已注册" });
    const meta: Record<string, unknown> = { user_type: "phone", phone };
    if (typeof body?.nickname === "string" && body.nickname.length > 0) meta.nickname = body.nickname;
    if (typeof body?.name === "string" && body.name.length > 0) meta.name = body.name;
    if (typeof body?.full_name === "string" && body.full_name.length > 0) meta.full_name = body.full_name;
    const { data, error } = await supabase.auth.admin.createUser({
      phone,
      password,
      phone_confirm: true,
      user_metadata: meta,
    });
    if (error) return json(400, { code: 400, message: error.message });
    return json(200, { code: 200, data: { userId: data.user?.id } });
  } catch (e) {
    return json(500, { code: 500, message: String(e) });
  }
});