From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: a.out coredumping: fix or delete?
Date: Sat, 2 Mar 2019 17:09:16 -0800
Message-ID: <CALCETrVJaYADYGswWgba=bysFEOP5jKuV3MxcZx5WFQEmxnGfg@mail.gmail.com>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 1, 2019 at 3:57 PM Jann Horn <jannh@google.com> wrote:
>
> In theory, Linux can dump cores for a.out binaries. In practice, that
> code is pretty bitrotten and buggy. Does anyone want that code so much
> that they'd like to fix it, or can we just delete it?

I would propose just deleting it.
