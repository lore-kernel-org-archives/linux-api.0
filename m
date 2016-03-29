From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/2] selftest/seccomp: Fix the flag name
 SECCOMP_FILTER_FLAG_TSYNC
Date: Tue, 29 Mar 2016 13:06:37 -0600
Message-ID: <56FAD23D.1020205@osg.samsung.com>
References: <56FAA0CC.2050201@osg.samsung.com>
 <1459277167-9973-1-git-send-email-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-2862-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1459277167-9973-1-git-send-email-mic@digikod.net>
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-security-module@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 03/29/2016 12:46 PM, Mickaël Salaün wrote:
> Rename SECCOMP_FLAG_FILTER_TSYNC to SECCOMP_FILTER_FLAG_TSYNC to match
> the UAPI.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Shuah Khan <shuahkh@osg.samsung.com>
> Cc: Will Drewry <wad@chromium.org>
> ---
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Thanks. Applied to linux-kselftest fixes for 4.6-rc2

-- Shuah
