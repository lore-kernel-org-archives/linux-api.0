From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] mtdchar: fix overflows in adjustment of `count`
Date: Sat, 7 Jul 2018 11:03:00 +0200
Message-ID: <CAG48ez3MUm=0iJSY21BNOFBJt=gWgGAQTwM8cz5d_wNwpMyQeg@mail.gmail.com>
References: <20180707033722.219468-1-jannh@google.com>
 <20180707104412.1580a285@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20180707104412.1580a285@bbrezillon>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: boris.brezillon@bootlin.com
Cc: richard@nod.at, kernel list <linux-kernel@vger.kernel.org>, marek.vasut@gmail.com, linux-mtd@lists.infradead.org, Linux API <linux-api@vger.kernel.org>, computersforpeace@gmail.com, dwmw2@infradead.org
List-Id: linux-api@vger.kernel.org

+cc linux-api

On Sat, Jul 7, 2018 at 10:44 AM Boris Brezillon
<boris.brezillon@bootlin.com> wrote:
>
> On Sat,  7 Jul 2018 05:37:22 +0200
> Jann Horn <jannh@google.com> wrote:
>
> > The first checks in mtdchar_read() and mtdchar_write() attempt to limit
> > `count` such that `*ppos + count <= mtd->size`. However, they ignore the
> > possibility of `*ppos > mtd->size`, allowing the calculation of `count` to
> > wrap around. `mtdchar_lseek()` prevents seeking beyond mtd->size, but the
> > pread/pwrite syscalls bypass this.
> >
> > I haven't found any codepath on which this actually causes dangerous
> > behavior, but it seems like a sensible change anyway.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> >  drivers/mtd/mtdchar.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> > index cd67c85cc87d..02389528f622 100644
> > --- a/drivers/mtd/mtdchar.c
> > +++ b/drivers/mtd/mtdchar.c
> > @@ -160,8 +160,12 @@ static ssize_t mtdchar_read(struct file *file, char __user *buf, size_t count,
> >
> >       pr_debug("MTD_read\n");
> >
> > -     if (*ppos + count > mtd->size)
> > -             count = mtd->size - *ppos;
> > +     if (*ppos + count > mtd->size) {
> > +             if (*ppos < mtd->size)
> > +                     count = mtd->size - *ppos;
> > +             else
> > +                     count = 0;
> > +     }
>
> Hm, shouldn't we return -ERANGE or -EINVAL if *ppos >= mtd->size?

Hmm, good question.
The pread() manpage says that pread() can return the same errors as
lseek(), and the lseek() manpage says that -EINVAL is for when you're
trying to seek beyond the end of a seekable device. So from the
documentation, it sounds as if you're right.
But testing pread() beyond end of file for various things on my
machine seems to just return 0:

# cat pread.c
#include <unistd.h>
#include <stdlib.h>
int main(int argc, char **argv) {
  char buf[0x1000];
  off_t off = strtoul(argv[1], NULL, 0);
  pread(0, buf, 0x1000, off);
}
# gcc -o pread pread.c
# strace -e trace=pread64 ./pread 200000000 < /dev/sda1
pread64(0, "", 4096, 200000000)         = 0
+++ exited with 0 +++
# strace -e trace=pread64 ./pread 100000 <
/sys/kernel/debug/x86/tlb_single_page_flush_ceiling
pread64(0, "", 4096, 100000)            = 0
+++ exited with 0 +++
# strace -e trace=pread64 ./pread 20000000000 < /dev/dm-2
pread64(0, "", 4096, 20000000000)       = 0
+++ exited with 0 +++

Do you know of precedent for returning -EINVAL if *ppos is beyond the
end of the device?

> >
> >       if (!count)
> >               return 0;
> > @@ -246,7 +250,7 @@ static ssize_t mtdchar_write(struct file *file, const char __user *buf, size_t c
> >
> >       pr_debug("MTD_write\n");
> >
> > -     if (*ppos == mtd->size)
> > +     if (*ppos >= mtd->size)
> >               return -ENOSPC;
> >
> >       if (*ppos + count > mtd->size)
>

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
