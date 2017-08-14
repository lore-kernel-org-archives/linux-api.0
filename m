From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v4 0/4] seccomp: Implement SECCOMP_RET_KILL_PROCESS action
Date: Mon, 14 Aug 2017 16:46:22 -0400
Message-ID: <CAHC9VhTeotOHSD+qKG=TF-SidFT0-46GnE_pz=rjGt6gzr1mcw@mail.gmail.com>
References: <1502489117-70522-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1502489117-70522-1-git-send-email-keescook@chromium.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, Fabricio Voznika <fvoznika@google.com>, Tycho Andersen <tycho@docker.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>, Mathias Svensson <idolf@google.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Aug 11, 2017 at 6:05 PM, Kees Cook <keescook@chromium.org> wrote:
> This series is the result of Fabricio, Tyler, Will and I going around a
> few times on possible solutions for finding a way to enhance RET_KILL
> to kill the process group. There's a lot of ways this could be done,
> but I wanted something that felt cleanest. My sense of what constitutes
> "clean" has shifted a few times, and after continually running into
> weird corner cases, I decided to make changes to the seccomp action mask,
> which shouldn't be too invasive to userspace as it turns out. Everything
> else becomes much easier, especially after being able to use Tyler's
> new SECCOMP_GET_ACTION_AVAIL operation.
>
> This renames SECCOMP_RET_KILL to SECCOMP_RET_KILL_THREAD and adds
> SECCOMP_RET_KILL_PROCESS.

I just took a very quick look and I'm not seeing anything that would
cause any backwards compatibility issues for libseccomp.  You could
try running the libseccomp tests against a patched kernel to make
sure; the README has all the info you need (pay special attention to
the "live" tests, although those are pretty meager at the moment).

-- 
paul moore
www.paul-moore.com
