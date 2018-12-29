From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [Qemu-devel] d_off field in struct dirent and 32-on-64 emulation
Date: Fri, 28 Dec 2018 22:14:16 -0500
Message-ID: <20181229031416.GH5864@mit.edu>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
 <CAFEAcA92m4vhzjJ+B=mP_o6Wfhx1XSKo3uWxah3osh=u5UXFuw@mail.gmail.com>
 <9C6A7D45-CF53-4C61-B5DD-12CA0D419972@dilger.ca>
 <CAFEAcA9W+JK7_TrtTnL1P2ES1knNPJX9wcUvhfLwxLq9augq1w@mail.gmail.com>
 <20181229021157.GG5864@mit.edu>
 <20181229023721.GA9291@nautica>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <libc-alpha-return-98863-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20181229023721.GA9291@nautica>
To: Peter Maydell <peter.maydell@linaro.org>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, lucho@ionkov.net, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>, ericvh@gmail.com, hpa@zytor.com, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, rminnich@sandia.gov, v9fs-developer@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

On Sat, Dec 29, 2018 at 03:37:21AM +0100, Dominique Martinet wrote:
> > Are there going to be cases where a process or a thread will sometimes
> > want the 64-bit interface, and sometimes want the 32-bit interface?
> > Or is it always going to be one or the other?  I wonder if we could
> > simply add a new flag to the process personality(2) flags.
> 
> That would likely work for qemu user, but the qemu system+9p case is
> going to be more painful..
> More precisely, the 9p protocol does not plan for anything other than
> 64bit offset so if the vfs needs to hand out a 32bit offset we'll need
> to make a correspondance table between the 32bit offsets we hand off and
> the 64bit ones to use; unless some flag can be passed at lopen to tell
> the server to always hand out 32bit offsets for this directory... And if
> we do that then 9p servers will need a way to use both APIs in parallel
> for both types of directories.

How about if we add a fcntl(2) mediated flag, which is tied to a
struct file?  Would that be more or less painful for 9p and qemu
system+9p?

       	      	    	    	    	 	 - Ted
