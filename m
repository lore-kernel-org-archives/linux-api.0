From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 00/13] Introduce first class virtual address spaces
Date: Wed, 15 Mar 2017 09:57:36 -0700
Message-ID: <20170315165736.GE4033@bombadil.infradead.org>
References: <CALCETrXKvNWv1OtoSo_HWf5ZHSvyGS1NsuQod6Zt+tEg3MT5Sg@mail.gmail.com>
 <20170314161229.tl6hsmian2gdep47@arch-dev>
 <CALCETrX5gv+zdhOYro4-u3wGWjVCab28DFHPSm5=BVG_hKxy3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CALCETrX5gv+zdhOYro4-u3wGWjVCab28DFHPSm5=BVG_hKxy3A@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, Rich Felker <dalias@libc.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, ALSA development <alsa-devel@alsa-project.org>, USB list <linux-usb@vger.kernel.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, "J. Bruce Fields" <bfields@fieldses.org>, Max Filippov <jcmvbkbc@gmail.com>, Paul Mackerras <paulus@samba.org>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux@vger.kernel.org, linux-hexagon@vger.kernel.org, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Linux API <linux-api@vger.kernel.org>, Jeff
List-Id: linux-api@vger.kernel.org

On Wed, Mar 15, 2017 at 09:51:31AM -0700, Andy Lutomirski wrote:
> > VAS segments on the other side allow sharing of pure in memory data by
> > arbitrary related tasks without the need of a file. This becomes especially
> > interesting if one combines VAS segments with non-volatile memory since one can keep
> > data structures in the NVM and still be able to share them between multiple tasks.
> 
> What's wrong with regular mmap?

I think it's the usual misunderstandings about how to use mmap.
>From the paper:

   Memory-centric computing demands careful organization of the
   virtual address space, but interfaces such as mmap only give limited
   control. Some systems do not support creation of address regions at
   specific offsets. In Linux, for example, mmap does not safely abort if
   a request is made to open a region of memory over an existing region;
   it simply writes over it.

The correct answer of course, is "Don't specify MAP_FIXED".  Specify the
'hint' address, and if you don't get it, either fix up your data structure
pointers, or just abort and complain noisily.

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
