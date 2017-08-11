From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v6 3/6] seccomp: Sysctl to configure actions that are
 allowed to be logged
Date: Fri, 11 Aug 2017 12:35:32 -0700
Message-ID: <CAGXu5j+Q61-Kw+JeOLDSAxXzx=t04Nv43v9duvaFArdVZGWu1w@mail.gmail.com>
References: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
 <1502426037-3777-4-git-send-email-tyhicks@canonical.com> <CAGXu5jJzboJ47tZH_BkeXTYgD_QyTpK4gXd8FTpcj-acO-F+VQ@mail.gmail.com>
 <23a0adb0-4db0-52aa-831e-36ceca466636@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <23a0adb0-4db0-52aa-831e-36ceca466636-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Tycho Andersen <tycho-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 11, 2017 at 12:33 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> On 08/11/2017 02:17 PM, Kees Cook wrote:
>> One thought here: should "kill" be always forced on during a write?
>> This flag effectively cannot be disabled, so listing it (or not) in
>> the sysctl may be confusing...
>
> "kill" can be silenced in the current implementation. Lets hammer out
> whether or not that's the right thing to do and then we can discuss the
> sysctl behavior on write. I don't personally have any concerns about an
> admin being able to silence RET_KILL logs but let me know if you are
> against it.

Oh right, this is fine. Yeah, as long as the default is to log it
(which it is) I'm fine. Thanks!

-Kees

-- 
Kees Cook
Pixel Security
