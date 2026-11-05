Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793893025;
	b=TyOawflNPiBYrVPEYPvXZ458CFhkKh2UyoF3kpAoeibwiZ/cx4RdOz9T1WX10D7Balsz
	 1H3CltCBrRDCqKKYcRZsPxFzBW0pV3i+TcIs9N2PaArKitvTz0/hGoZTgRroyIrfJhKW0
	 bo0Q9lrbAvb0zpU17N5/Ykrntg1C9BN5Z47d/WeWCXE05w4dpYWFYWTORRbE0YD02gvKk
	 k1RrrT/owxi0v9Ji+Q2VD2NbplxHgnCJt9lTDAhswqbcwisPLqtaHIbpHDbUmtGU/ukpX
	 AVzqiLuP7eupAC3KLCnAFuuvX2wWBBCH4/SpfuERgOV7t/2hXHoh3ohebalaOQ3Rs0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793893025;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=kvailjwqfOmhbJJjcy8TbvowePxzON+06QO6Up9gGT0=;
	b=n2y/pdVdxhTyL/SjQKKTvoakvsx4tgZsZCvtK8kZ53ElCQ/I+mGVTADAYGBGOp4eqv7a
	 wyqhu2bxcHxqwQ+45Vzm9k5d4NDoq3ysdiJ3EFWVY9S8VZOT5wcMl07JFMvIzpDz0b80d
	 0sERCiLRhviqxtijW2HdOVISInl0eiGNazUlNAS/FKYl2+RNAKbYhwzr647qAtt3n8DVY
	 CuJmDPVzYcHD1PgkPO7uyZnrl9iL3CShSmCU1AovBN+KOjlw00S8NYy1g6zDIix6mSj4X
	 UeSNc2IQI3p0zRcUcETcc3aBYjvKO8jiXT6+h3rgE71vSQddkBedRNKhufeqUGzzi4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Gxle+Ke/";
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402AB606A31B
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 15:37:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 402AB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gxle+Ke/
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c40285df2a0so159598366b.2
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 07:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793893024; x=1794497824; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kvailjwqfOmhbJJjcy8TbvowePxzON+06QO6Up9gGT0=;
        b=Gxle+Ke/ft0qPJDBX0JQWzA1ZLmQgVZzBrWyEVoNZxTcMrrajfo1O4ASCBG23EIcjq
         cUy28QM3QPVKkqYviAKt4UuDyzpJABmNQR4JRuUY/9J9Hkfes1ObSbTFJBTMv0xgyn36
         I605vsADiFHcxXf4eX61I0j4Gi+kKyS6oNG5NvaDGMqTtAbtArrAfHjtJRgz0KAQXT73
         KzZfmQgJwuEWSDCZ0Dz1NtIeuRDvR+OePZg4x0U3S37xPzoaWN3MauXtR0KYCrK+pAhq
         rsIk4Yf8fmIvbb2p7AhpUlOpetxQvv3G4Qgr9XZcKOy2pWy+dVo2136CYJcH164SwW/n
         pIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793893024; x=1794497824;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kvailjwqfOmhbJJjcy8TbvowePxzON+06QO6Up9gGT0=;
        b=LMsZI0XxixLnz84HliQzOmSDNN45AOpWOYhmnM4qCgihEHDByJLcfMXR4girV1Q9jp
         F1j6I5b30IJpZQTkli+gveMR15YUU63qazVfuw7db6/k9MsoXhwMkdbONSTI1bL5Fqpr
         6k9Mb7pAR+ZU+884A/d6GFXlDeDz3Dv0xFWxpdQSjDC2ngw7sKGcCbQnxUd1A1TATorK
         TCrQqfX7i3TiYwMHfR5NgTllv88zBg6kUCSVeuTXYpnCgWbXYAPSqDD8buu0EUz3lmcD
         XXBgHfnn8ZxE1qMDidEouU8Fn533ThGM8HUxucAQiak6pzE2senaBnsBxtG3t36XfsMa
         icXA==
X-Forwarded-Encrypted: i=1; AKwUvBwXzmksDTLmRwLlQzgrsTdrQjTfLYgxQN4FbwxRk69gjgya01q7J2uc8MSi039BGhHeE2OpOf3Gd9w=@vger.kernel.org
X-Gm-Message-State: APuU4Z9iQVuYBM/9lD6JH7oMxy6BmKj4CmReTXXnwibyl96wix1K6Ptc
	bX5V3Qj5mV/8NlQrmDXaoW1gcjpxxK7HuvtzVCACOjniQPLhaqvHexirmO0ZKQ3an4urJdxmXg=
	=
X-Received: from ejcwz8-n2.prod.google.com ([2002:a17:907:b048:20b0:c4d:23d9:b0d9])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:cb88:b0:c26:19e3:e98d
 with SMTP id a640c23a62f3a-c4ca7af17a5mr1750569566b.45.1793893023363; Thu, 05
 Nov 2026 07:37:03 -0800 (PST)
Date: Thu, 5 Nov 2026 15:37:02 +0000
In-Reply-To: <aunVmg42/S2uUDWR@hallyn.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com> <aunVmg42/S2uUDWR@hallyn.com>
Message-ID: <auyink594bxptAPN@google.com>
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jan Kara <jack@suse.cz>, 
	James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-api@vger.kernel.org, containers@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, Nov 03, 2026 at 06:37:46AM -0600, Serge E. Hallyn wrote:
> Generally, if I, or some users I support, need to use unprivileged containers
> or user namespaces, then when an 0day comes along, I can hopefully trust them
> not to exploit it.  The biggest danger comes from the fact that, right now, if
> they can use them, anyone can.  So if someone can trigger some other code running
> as user nginx or something, that can become a root vector.
> 
> So what if we had a built-in feature or LSM which implemented a credential based
> whitelist, entered at firstboot?  Something like
> 
> ```
> # Default deny
> uid == 1000  # approved
> 1005 < uid < 1010  # approved
> gid == 1005
> security_label = lxc_user_t  # Not sure how far we want to go with this
> tty # must have a session
> ```
> 
> Now, if you want to use user namespaces for generic sandboxes for all
> users, e.g. to confine browser activity or nginx modules, then this model
> may not fit.  Or rather, it might need a few tweaks.

Thanks for taking a look and sharing the credential-based allowlist.

The latter scenario (generic sandboxes for all users) is actually the
primary use case that I'm targeting. I want to allow unprivileged users to
create user namespaces, e.g. for sandboxing, but without granting them
security-sensitive network capabilities (CAP_NET_ADMIN/CAP_NET_RAW) when
they are not strictly needed, given the historically high risk of local
privilege escalation associated with them.

The two approaches target complementary layers of the problem. A credential
allowlist at creation time controls who can create a user namespace, while
this patch series controls what capabilities are available inside that
namespace (and its descendants) once it is created.

Gating creation works well when there is a clear boundary between trusted
and untrusted users. However, in a multi-tenant environment (like a large
container fleet), we generally treat workloads as untrusted by default.
Because we still want to allow these untrusted workloads to use unprivileged
user namespaces for sandboxing, it is essential to keep the attack surface
small and follow the principle of least privilege whenever possible.

More specifically, this patch series enables that model of safe sandboxing
across three key use cases:

1. Configurable capability stripping: Administrators can enable unprivileged
   user namespaces for all users to support sandboxing, but configure the
   system to strip CAP_NET_ADMIN and CAP_NET_RAW by default in new user
   namespaces created by unprivileged users. Basic sandboxing rarely needs
   these (except to bring up loopback, which Patch 1 addresses via
   CLONE_NEWNET_LOOPBACK).

   The per-namespace bounding set can enforce this either globally via the
   sysctl, or explicitly via clone3() at the container manager level. This
   restriction is monotonic and persists down the namespace hierarchy.

2. Selectively granting CAP_NET_ADMIN: Some containerized workloads
   legitimately need CAP_NET_ADMIN to configure advanced networking for
   sub-containers. Because an unprivileged creator's child namespace is
   bounded by:

     parent_bset & (sysctl_ceiling | creator_effective)

   a container that is explicitly granted CAP_NET_ADMIN in its own user
   namespace automatically propagates that capability into the bounding
   set of any child namespace it creates (unless it is explicitly
   dropped).

3. Dropping capabilities for nested namespaces: If a container with
   CAP_NET_ADMIN needs to spawn an inner user namespace to run untrusted
   code in a nested sandbox, it can use CLONE_NEWUSER_BSET to voluntarily
   drop CAP_NET_ADMIN from the inner namespace's bounding set. This
   guarantees the nested sandbox cannot access the capability and the
   restriction persists for all further descendants.

As a quick clarification on how this interacts with the hierarchy: the
bounding set restricts tasks inside the namespace and parent tasks
relying purely on the parent-ownership check. It does not restrict
tasks in an ancestor userns that inherently hold the capability.
Therefore, in the nested sandbox scenario above (#3), the parent
container with CAP_NET_ADMIN can still configure the sandbox's network
from the outside (by using setns() to enter the nested netns directly)
even though CAP_NET_ADMIN is stripped inside the sandbox userns.

