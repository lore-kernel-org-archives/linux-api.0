From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [tip GIT PULL v2] y2038: timekeeping syscall changes
Date: Thu, 19 Apr 2018 13:59:57 +0200
Message-ID: <CAMuHMdXNHaBVMqrQOfBuN+Ro4SC40B9OxCs9HsNM_c4fxcJT0g@mail.gmail.com>
References: <CAK8P3a0-n-Qabdr+5hwjq8wa9nZHtFwcE32WsW8ZTbKjtpiBUQ@mail.gmail.com>
 <CAK8P3a3vS1AWHGMmGchQOrkV40GESNuJHQfZF-YDtOwZ1Z18Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3vS1AWHGMmGchQOrkV40GESNuJHQfZF-YDtOwZ1Z18Dw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, y2038 Mailman List <y2038@lists.linaro.org>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Arnd,

On Thu, Apr 19, 2018 at 1:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Apr 19, 2018 at 1:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:
>>
>>   Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)
>>
>> are available in the git repository at:
>>
>>   git+ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
>> tags/y2038-timekeeping
>
> That one is still messed up. I changed my .gitconfig to have a
> different "insteadof"
> section, but for some reason that failed. Obviously the URL I meant is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
> tags/y2038-timekeeping
>
> I've never figured out how to configure this correctly and try to
> manually edit the
> pull request, but forget to do that half of the time.

I use:

[remote "foo"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/user/foo.git
        pushurl = gitolite.kernel.org:/pub/scm/linux/kernel/git/user/foo.git

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
