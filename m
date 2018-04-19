From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [tip GIT PULL v2] y2038: timekeeping syscall changes
Date: Thu, 19 Apr 2018 14:03:30 +0200
Message-ID: <CAK8P3a0bMxupCGnrzOomACmgdkfoE8BYmyx_UX1OLeBmdNx7+A@mail.gmail.com>
References: <CAK8P3a0-n-Qabdr+5hwjq8wa9nZHtFwcE32WsW8ZTbKjtpiBUQ@mail.gmail.com>
 <CAK8P3a3vS1AWHGMmGchQOrkV40GESNuJHQfZF-YDtOwZ1Z18Dw@mail.gmail.com> <CAMuHMdXNHaBVMqrQOfBuN+Ro4SC40B9OxCs9HsNM_c4fxcJT0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdXNHaBVMqrQOfBuN+Ro4SC40B9OxCs9HsNM_c4fxcJT0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, y2038 Mailman List <y2038@lists.linaro.org>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 19, 2018 at 1:59 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Arnd,
>
> On Thu, Apr 19, 2018 at 1:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Thu, Apr 19, 2018 at 1:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:
>>>
>>>   Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)
>>>
>>> are available in the git repository at:
>>>
>>>   git+ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
>>> tags/y2038-timekeeping
>>
>> That one is still messed up. I changed my .gitconfig to have a
>> different "insteadof"
>> section, but for some reason that failed. Obviously the URL I meant is
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
>> tags/y2038-timekeeping
>>
>> I've never figured out how to configure this correctly and try to
>> manually edit the
>> pull request, but forget to do that half of the time.
>
> I use:
>
> [remote "foo"]
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/user/foo.git
>         pushurl = gitolite.kernel.org:/pub/scm/linux/kernel/git/user/foo.git

Thanks! I've figured something out now using 'insteadOf' and
'pushInsteadOf' config options to the same effect. I had a
separate pushurl in the past but that broke when I added
an insteadOf substitution without adding pushInsteadOf.

       Arnd
