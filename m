From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] set the thread name
Date: Wed, 17 Jun 2009 10:13:37 +0900 (JST)
Message-ID: <20090617100803.99C1.A69D9226@jp.fujitsu.com>
References: <1245177592.14543.1.camel@wall-e> <36ca99e90906161214u6624014q3f3dc4e234bdf772@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <36ca99e90906161214u6624014q3f3dc4e234bdf772@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: kosaki.motohiro@jp.fujitsu.com, Stefani Seibold <stefani@seibold.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

(cc to linux-api)

> Hi,
> 
> On Tue, Jun 16, 2009 at 20:39, Stefani Seibold<stefani@seibold.net> wrote:
> > Currently it is not easy to identify a thread in linux, because there is
> > no thread name like in some other OS.
> >
> > If there were are thread name then we could extend a kernel segv message
> > and the /proc/<pid>/task/<tid>/... entries by a TName value like this:
> prctl(PR_SET_NAME, ...) works perfectly here.

Oops, but man page describe another thing.

       PR_SET_NAME
              (Since Linux 2.6.9) Set the process name for the calling process
              to arg2.                    ^^^^^^^^^^^^

Should we change man page? or change implementation?

I bet many developer assume the implementation is right.


> 
> Bert
> 
> /* -*- c -*- */
> 
> #define _GNU_SOURCE
> #include <unistd.h>
> #include <stdlib.h>
> #include <stdio.h>
> #include <string.h>
> #include <stdint.h>
> #include <stdbool.h>
> #include <math.h>
> #include <pthread.h>
> #include <sys/prctl.h>
> 
> void *
> thread(void *arg)
> {
>     unsigned long i = (unsigned long)arg;
>     char comm[16];
>     snprintf(comm, sizeof comm, "task %02lu", i);
>     prctl(PR_SET_NAME, comm, 0l, 0l, 0l);
> 
>     sleep(10);
> 
>     return NULL;
> }
> 
> int
> main(int ac, char *av[])
> {
>     pthread_t thr;
>     unsigned long i, n = 10;
>     char comm[16];
> 
>     printf("%u\n", getpid());
>     sleep(5);
>     snprintf(comm, sizeof comm, "master");
>     prctl(PR_SET_NAME, comm, 0l, 0l, 0l);
>     sleep(5);
> 
>     for (i = 0; i < n; i++)
>         pthread_create(&thr, NULL, thread, (void *)i);
> 
>     pthread_join(thr, NULL);
> 
>     return 0;
> }
> 
> >
> > Greetings,
> > Stefani
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at ?http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at ?http://www.tux.org/lkml/
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
