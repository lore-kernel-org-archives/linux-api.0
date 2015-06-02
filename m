From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Tue, 2 Jun 2015 20:48:48 +0200
Message-ID: <20150602184848.GA24907@redhat.com>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com> <CANaxB-zacYuo21jLVZyEfyf=UdDnTjYvHdgNpfL+c_DXWRz-eg@mail.gmail.com> <20150602130506.GA1823@hopstrocity>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150602130506.GA1823@hopstrocity>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho.andersen@canonical.com>
Cc: Andrey Wagin <avagin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org

On 06/02, Tycho Andersen wrote:
>
> > Do we need to re-enable seccomp if a tracer detaches unexpectedly.
> > CRIU can be killed and we should try to not affect the task state even
> > in this case.
>
> Yes, I think Pavel's suggestion on the CRIU list of simply
> automatically re-enabling seccomp on ptrace detach

But note that you can't enable tsc if the tracer dies, in this case
the tracee can be running.

Otherwise, if we use PTRACE_O_ instead, it goes away automatically if
the tracer dies or does PTRACE_DETACH.

Oleg.
