From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC] Add critical process prctl
Date: Tue, 10 Sep 2019 09:56:53 -0700
Message-ID: <CALCETrU2Wycgdfo8vLZQUnx1J9ro=6ddSkP37BhsfBkKL1mbMA@mail.gmail.com>
References: <20190905005313.126823-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190905005313.126823-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Tim Murray <timmurray@google.com>, Suren Baghdasaryan <surenb@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 4, 2019 at 5:53 PM Daniel Colascione <dancol@google.com> wrote:
>
> A task with CAP_SYS_ADMIN can mark itself PR_SET_TASK_CRITICAL,
> meaning that if the task ever exits, the kernel panics. This facility
> is intended for use by low-level core system processes that cannot
> gracefully restart without a reboot. This prctl allows these processes
> to ensure that the system restarts when they die regardless of whether
> the rest of userspace is operational.

The kind of panic produced by init crashing is awful -- logs don't get
written, etc.  I'm wondering if you would be better off with a new
watchdog-like device that, when closed, kills the system in a
configurable way (e.g. after a certain amount of time, while still
logging something and having a decent chance of getting the logs
written out.)  This could plausibly even be an extension to the
existing /dev/watchdog API.

--Andy
