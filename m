From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH resend 1/2] capability: introduce sysctl for controlled
 user-ns capability whitelist
Date: Thu, 9 Nov 2017 11:30:37 -0600
Message-ID: <20171109173037.GC26229@mail.hallyn.com>
References: <20171103004433.39954-1-mahesh@bandewar.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-10489-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20171103004433.39954-1-mahesh@bandewar.net>
To: Mahesh Bandewar <mahesh@bandewar.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Serge Hallyn <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <maheshb@google.com>
List-Id: linux-api@vger.kernel.org

Quoting Mahesh Bandewar (mahesh@bandewar.net):
> From: Mahesh Bandewar <maheshb@google.com>
> 
> Add a sysctl variable kernel.controlled_userns_caps_whitelist. This

I understand the arguments in favor of whitelists in most cases for
security purposes.  But given that you've said the goal here is to
prevent use of a capability in a user namespace when a CVE has been
found, a whitelist seems the wrong choice, since

1. it means that an attacker may through some other means be able
to add a capability back into the whitelist when you specifically
wanted to drop it.  With a blacklist, you could say "once a cap has
been dropped it can never be re-added without rebooting".
2. it means by default all capabilities will be denied once the
switch is pulled which is specifically not what you want in this
case.
3. the admin can't just say "drop CAP_NET_ADMIN", but needs to
know to echo ~CAP_NET_ADMIN.

Why not make it a blacklist, and once a cap is dropped it can
never be re-added?

-serge
