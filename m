From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Mon, 14 Mar 2011 22:22:44 +0100
Message-ID: <201103142222.44598.arnd@arndb.de>
References: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net> <20110314131042.5a7fb32f.akpm@linux-foundation.org> <20110314211119.GC8120@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110314211119.GC8120@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, G@thunk.org, Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>, Jonathan Nieder <jrnieder@gmail.com>, Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, linux-api@vger.kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Monday 14 March 2011 22:11:19 Ted Ts'o wrote:
> It wouldn't hurt to have a "flags" field which we could expand later
> --- but that can lead to portability headaches for userspace programs
> that don't know whether a particular kernel is going to support a
> particular flag or not.  So it's certainly not a panacea.

I think adding an unused flags argument can't hurt.

We could be fancy and ignore half the bits but bail out on the other
half with -EINVAL. That would make it possible to add both compatible
(default being full sync on old kernels) and incompatible (getting
rejected on old kernels) flags.

	Arnd
