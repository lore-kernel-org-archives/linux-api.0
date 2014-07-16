From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v10 0/11] seccomp: add thread sync ability
Date: Wed, 16 Jul 2014 14:27:38 -0700
Message-ID: <CALCETrUXRszBEhB7aOu6nXtCj09zofY_b_5BUNbJk-EFefA6fw@mail.gmail.com>
References: <1405017631-27346-1-git-send-email-keescook@chromium.org>
 <20140711164931.GA18473@redhat.com> <CAGXu5jK-x0=Rr7kX2a=b4Z8ueA77uwmhNZZAayG8cwmNOKa8Ug@mail.gmail.com>
 <CALCETrVXgA9a2f7VwnCYW4_XB+JAPRSR8xsuH_ZYbA82=ZozRw@mail.gmail.com>
 <CAGXu5j+r-CpJiXipCT=j09+ZfJjF9jTc3kuZFAH3ZxgUEvktTA@mail.gmail.com>
 <CALCETrX48nuR6wqEV4Nu47BF4Z3XFvBpYer_fzwaqJdi0fpdKw@mail.gmail.com> <CAGXu5jKMwiAxeCVZVPS72XWCd2KhiR-uc4VFKT0mvD9s-cTO_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKMwiAxeCVZVPS72XWCd2KhiR-uc4VFKT0mvD9s-cTO_Q@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 16, 2014 at 2:23 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jul 16, 2014 at 12:45 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> In seccomp_prepare_user_filter, would it make sense to return -EINVAL
>> if !user_filter?  That will make it slightly more pleasant to
>> implement TSYNC-without-change if anyone ever wants it.  (This isn't
>> really necessary -- it's just slightly more polite.)
>
> I can't do this since EFAULT is already used to detect seccomp
> capabilities from userspace.

Aha.  In that case, can you (separately) send a prctl.2 manpage patch
documenting that?  Also, I'm pretty sure you can get away with doing
this for seccomp(2) -- EINVAL and ENOSYS are easily distinguishable,
but the current behavior is IMO also fine if documented.

--Andy
