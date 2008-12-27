From: Andreas Bombe <andreas.bombe@mytum.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
	(corrected)
Date: Sat, 27 Dec 2008 01:49:28 +0100
Message-ID: <20081227004928.GA28225@case.infernal>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com> <20081211003340.GB3078@local> <20081225123004.GA13640@8bytes.org> <20081225152014.GA3079@local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753535AbYL0At5@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081225152014.GA3079@local>
Sender: linux-kernel-owner@vger.kernel.org
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Joerg Roedel <joro@8bytes.org>, Edward Estabrook <edward.estabrook.lkml@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@suse.de, edward.estabrook@gmail.com, edward_estabrook@agilent.com
List-Id: linux-api@vger.kernel.org

On Thu, Dec 25, 2008 at 04:20:15PM +0100, Hans J. Koch wrote:
> On Thu, Dec 25, 2008 at 01:30:04PM +0100, Joerg Roedel wrote:
> > I like that idea of a seperate directory in sysfs. How about allocating
> > DMA memory by creating files in this directory.
> 
> Nice idea, but AFAICT sysfs doesn't support creating files from userspace.

For that there is configfs.
