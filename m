From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 0/5] y2038: Make ppoll, io_pgetevents and pselect y2038 safe
Date: Thu, 6 Dec 2018 17:26:54 +0100
Message-ID: <CAK8P3a1d6KnCoGLY4tfkZzNVYBuWpHcov0se1ymtCGRMWOeTWw@mail.gmail.com>
References: <20180920044108.6606-1-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180920044108.6606-1-deepa.kernel@gmail.com>
Sender: owner-linux-aio@kvack.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: viro@zeniv.linux.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-aio@kvack.org
List-Id: linux-api@vger.kernel.org

On 9/20/18, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> The series transitions the ppoll, io_getevents, and pselect syscalls
> to be y2038 safe.
>
> This is part of the work proceeding for syscalls for y2038.
> It is based on the series [1] from Arnd Bergmann.
>
> The overview of the series is as below:
> 1. Refactor sigmask handling logic for the above syscalls.
> 2. Provide y2038 safe versions of the syscalls for all ABIs.
>
> [1] https://lkml.org/lkml/2018/8/27/651

I'm sorry for dropping the ball on this earlier, so it already
missed the 4.20 merge window, and is getting almost too
late for 4.21 as well now.

I've applied your five patches to my y2038 tree now, so
it should at least be in linux-next as of tomorrow and
make it into 4.21. I'll see what other patches I have in
my backlog that we should get into that release before
I send him a pull request.

      Arnd

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
