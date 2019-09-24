From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Tue, 24 Sep 2019 21:42:35 +0200
Message-ID: <27cc0db0-f3b4-e4c5-70cc-2f93814c460b@gmail.com>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
 <CAKOZuetMK0eRxBrR8wXo_qCaQ7OGKQHqAy15cX437+Q+cvbbvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuetMK0eRxBrR8wXo_qCaQ7OGKQHqAy15cX437+Q+cvbbvA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: mtk.manpages@gmail.com, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 9/23/19 1:31 PM, Daniel Colascione wrote:
> On Mon, Sep 23, 2019 at 2:12 AM Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>>        The  pidfd_send_signal()  system call allows the avoidance of race
>>        conditions that occur when using traditional interfaces  (such  as
>>        kill(2)) to signal a process.  The problem is that the traditional
>>        interfaces specify the target process via a process ID (PID), with
>>        the  result  that the sender may accidentally send a signal to the
>>        wrong process if the originally intended target process has termi‐
>>        nated  and its PID has been recycled for another process.  By con‐
>>        trast, a PID file descriptor is a stable reference to  a  specific
>>        process;  if  that  process  terminates,  then the file descriptor
>>        ceases to be  valid
> 
> The file *descriptor* remains valid even after the process to which it
> refers exits. You can close(2) the file descriptor without getting
> EBADF. I'd say, instead, that "a PID file descriptor is a stable
> reference to a specific process; process-related operations on a PID
> file descriptor fail after that process exits".

Thanks, Daniel. I like that rephrasing, but, since pidfd_send_signal()
is (so far as I know) currently the only relevant process-related
operation (and because this is the manual page describing that
syscall), I made it:

[[
By contrast, a PID file descriptor is a stable reference to a
specific process; if that process terminates, pidfd_send_signal()
fails with the error ESRCH.
]]

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
