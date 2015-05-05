From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] ipc/sem: 64bit union semun definition
Date: Tue, 05 May 2015 23:40:17 +0200
Message-ID: <3111248.ei0HoJaVIp@wuerfel>
References: <1430850523-7522-1-git-send-email-a22017@motorola.com> <2165666.hrkl3t0kHm@wuerfel> <CACwVHNr9K0XXvB8JVEet_OtTRAJmjkHTsKsOc9h5HNts9+X5QA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACwVHNr9K0XXvB8JVEet_OtTRAJmjkHTsKsOc9h5HNts9+X5QA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sandy Sun <a22017-3WKxDLwmzFNWk0Htik3J/w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 05 May 2015 14:09:14 Sandy Sun wrote:
> Hi Arnd,
> 
> If user space uses union semun to define.It will use semid_ds not
> semid64_ds.
> 
> I used LTP test case semctl01 IPC_STAT to do the test on 64 bit
> system.According to the test results:
> 
> Before the change, semun uses semid_ds, the field of sem_nsems reporting of
> semaphore STAT info is incorrect:
> 
> semctl01    1  TFAIL  :  semaphore STAT info is incorrect
> semctl01    2  TFAIL  :  semaphore mode info is incorrect
> 
> After this change, the return value is correct:
> semctl01    1  TPASS  :  buf.sem_nsems and buf.sem_perm.mode are correct
> semctl01    2  TPASS  :  buf.sem_perm.mode is correct

I don't understand: semctl01 does not reference 'union semun64'. How
does this change make a difference, and why would that difference
be limited to 64-bit systems?

	Arnd
