From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Mon, 23 Sep 2019 16:27:45 -0500
Message-ID: <87ftkmu2i6.fsf@x220.int.ebiederm.org>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com> (Michael
        Kerrisk's message of "Mon, 23 Sep 2019 11:12:00 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Hello Christian and all,
>
> Below, I have the rendered version of the current draft of
> the pidfd_send_signal(2) manual page that I have written.
> The page source can be found in a Git branch at:
> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_pidfd
>
> I would be pleased to receive corrections and notes on any
> details that should be added. (For example, are there error
> cases that I have missed?)
>
> Would you be able to review please?
>
> Thanks,
>
> Michael
>
>
> NAME
>        pidfd_send_signal - send a signal to a process specified by a file
>        descriptor
>
> SYNOPSIS
>        int pidfd_send_signal(int pidfd, int sig, siginfo_t info,

 This needs to be "siginfo_t *info," -----------------------^

>                              unsigned int flags);
>

Eric
