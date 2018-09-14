From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH 3/5] ppoll: use __kernel_timespec
Date: Fri, 14 Sep 2018 15:07:09 -0700
Message-ID: <CABeXuvrnzJJaZS-xp4+H7848+wbQ2TqsN9cVbM08a2naoyApCQ@mail.gmail.com>
References: <20180901204721.13117-1-deepa.kernel@gmail.com>
 <20180901204721.13117-4-deepa.kernel@gmail.com> <CAK8P3a1zQBQz1ZtNZzkceut4k3eLjOjCwvOtBdEmc9cTsaFz+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAK8P3a1zQBQz1ZtNZzkceut4k3eLjOjCwvOtBdEmc9cTsaFz+g@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-aio <linux-aio@kvack.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 14, 2018 at 8:57 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sat, Sep 1, 2018 at 10:48 PM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>
> > +
> > +       /* We can restart this syscall, usually */
> > +       if (ret == -EINTR) {
> > +               restore_user_sigmask(sigmask, &sigsaved);
> > +               ret = -ERESTARTNOHAND;
> > +       }
>
> I need a little help understanding this part: In the two existing copies of that
> function, you have changed it to
>
>         restore_user_sigmask(sigmask, &sigsaved);
>         if (ret == -EINTR)
>                 ret = -ERESTARTNOHAND;
>
> in the previous patch, but the new new copies you add here do
>
>        if (ret == -EINTR) {
>                restore_user_sigmask(sigmask, &sigsaved);
>                ret = -ERESTARTNOHAND;
>        }
>
> Is that intentional, or did you accidently leave a version in here that
> you had changed afterwards?

Oops, you are right. This wasn't intentional.
I will send out a v2.

Thanks,
Deepa

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
