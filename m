From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v2] selftests/seccomp: Get page size from sysconf
Date: Mon, 16 Nov 2015 16:42:21 +1100
Message-ID: <1447652541.959.8.camel@ellerman.id.au>
References: <1447384671-17758-1-git-send-email-bamvor.zhangjian@linaro.org>
	 <CAGXu5jJxxtfOfUzjWByh+wyVb56U2k42SneLnnE8dST8r_Yz=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jJxxtfOfUzjWByh+wyVb56U2k42SneLnnE8dST8r_Yz=A@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Sesek <rsesek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2015-11-13 at 14:41 -0800, Kees Cook wrote:

> On Thu, Nov 12, 2015 at 7:17 PM, Bamvor Jian Zhang
> <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> > The commit fd88d16c58c2 ("selftests/seccomp: Be more precise with
> > syscall arguments.") use PAGE_SIZE directly which lead to build
> > failure on arm64.
> > 
> > Replace it with generic interface(sysconf(_SC_PAGESIZE)) to fix this
> > failure.
> > 
> > Build and test successful on x86_64 and arm64.
> > 
> > Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> 
> Shuah, can you please pull this for kselftest? It fixes arm64 after
> Robert's changes.

Also works on powerpc with 64k pages.

Tested-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

cheers
