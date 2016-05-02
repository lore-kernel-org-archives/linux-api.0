From: James Morris <jmorris@namei.org>
Subject: Re: [RFC v1 00/17] seccomp-object: From attack surface reduction to
 sandboxing
Date: Tue, 3 May 2016 08:19:34 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1605030816180.21933@namei.org>
References: <1458784008-16277-1-git-send-email-mic@digikod.net> <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <kernel-hardening-return-3138-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-security-module <linux-security-module@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Will Drewry <wad@chromiu>
List-Id: linux-api@vger.kernel.org

On Wed, 27 Apr 2016, Kees Cook wrote:

> Doing "b" means writing a policy engine. I would expect it to look a
> lot like either AppArmor or TOMOYO. TOMOYO has network structure
> processing, so probably it would look more like TOMOYO if you wanted
> more than just file paths. Maybe a seccomp LSM could share logic from
> one of the existing path-based LSMs.

Right, and that LSM should probably be AppArmor, which is actually being 
used and maintained.


-- 
James Morris
<jmorris@namei.org>
