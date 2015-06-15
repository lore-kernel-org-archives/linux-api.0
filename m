From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v5] seccomp: add ptrace options for suspend/resume
Date: Mon, 15 Jun 2015 23:20:18 +0200
Message-ID: <20150615212017.GA10538@redhat.com>
References: <1434207768-16729-1-git-send-email-tycho.andersen@canonical.com> <20150613235250.GA25252@redhat.com> <CAGXu5jJt93GKadDonjgYkrjh2Z44QyyzxmJwNOt1MVNM9gekJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJt93GKadDonjgYkrjh2Z44QyyzxmJwNOt1MVNM9gekJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho.andersen@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On 06/15, Kees Cook wrote:
>
> On Sat, Jun 13, 2015 at 4:52 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 06/13, Tycho Andersen wrote:
> >>
> >> This patch is the first step in enabling checkpoint/restore of processes
> >> with seccomp enabled.
> >
> > So just in case, I am fine with this version.
>
> Should I add your Ack? Though I really like the idea of a
> "Fine-with-this:" tag. ;)

Yes, please feel free to add ;)

Oleg.
