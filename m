From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/14] y2038 syscall changes for 4.20
Date: Wed, 29 Aug 2018 15:59:11 +0200
Message-ID: <CAK8P3a2vuDRnPzLQU1TeGfdPRjdZ9R2EkbDVerogJ7tJOoy8zg@mail.gmail.com>
References: <20180827194531.3796559-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827194531.3796559-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Deepa Dinamani <deepa.kernel@gmail.com>, linux-arch <linux-arch@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 27, 2018 at 9:45 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Hi Thomas,
>
> I've rebased the syscall changes on top of 4.19-rc1, and the old_time32
> rename. This is the first set of those patches, the ones that I hope
> are all uncontroversial and obvious now. I'm still in the process of
> reorganizing and testing the next set batch top, and plan to send them
> after you've merged these.
>
> The first three patches are new here, the other ones have been posted
> before a few times.

Update: I've added the patch from the kbuild test robot, and pushed
the series to

git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git y2038

from where it should get picked up into linux-next. If there are
no concerns about the rest of the content, please pull from there.

      Arnd
