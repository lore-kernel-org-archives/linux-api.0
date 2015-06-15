From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5] seccomp: add ptrace options for suspend/resume
Date: Mon, 15 Jun 2015 15:04:12 -0700
Message-ID: <CAGXu5jK9XA6hpjvOma647aKmLL7q89UJhQy_0BB90wUSPNT0hQ@mail.gmail.com>
References: <1434207768-16729-1-git-send-email-tycho.andersen@canonical.com>
	<20150613235250.GA25252@redhat.com>
	<CAGXu5jJt93GKadDonjgYkrjh2Z44QyyzxmJwNOt1MVNM9gekJQ@mail.gmail.com>
	<20150615212017.GA10538@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150615212017.GA10538@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tycho Andersen <tycho.andersen@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 15, 2015 at 2:20 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/15, Kees Cook wrote:
>>
>> On Sat, Jun 13, 2015 at 4:52 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > On 06/13, Tycho Andersen wrote:
>> >>
>> >> This patch is the first step in enabling checkpoint/restore of processes
>> >> with seccomp enabled.
>> >
>> > So just in case, I am fine with this version.
>>
>> Should I add your Ack? Though I really like the idea of a
>> "Fine-with-this:" tag. ;)
>
> Yes, please feel free to add ;)

Thanks!

I've added this to the seccomp tree. It may be a bit delayed appearing
in -next, due to 4.2 opening soon.

-Kees

-- 
Kees Cook
Chrome OS Security
