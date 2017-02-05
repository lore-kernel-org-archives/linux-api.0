From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] prctl: implement PR_GET_ENDIAN for all architectures
Date: Sun, 5 Feb 2017 13:15:48 +0000 (GMT)
Message-ID: <alpine.LFD.2.20.1702051300010.27997@eddie.linux-mips.org>
References: <20170128111310.GA13389@ls3530.fritz.box> <20170131162624.5a85ec47c6ee22e5cc03c4eb@linux-foundation.org> <1485990732.2322.40.camel@HansenPartnership.com> <CAEdQ38FXam3sXKFc5-3WEgDDov0yayAWXK8hbuNjbSxJQ5QDVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Received: from localhost.localdomain ([127.0.0.1]:56442 "EHLO
        localhost.localdomain" rhost-flags-OK-OK-OK-OK)
        by eddie.linux-mips.org with ESMTP id S23990507AbdBENPsNJm3U (ORCPT
        <rfc822;linux-api@vger.kernel.org> + 2 others);
        Sun, 5 Feb 2017 14:15:48 +0100
In-Reply-To: <CAEdQ38FXam3sXKFc5-3WEgDDov0yayAWXK8hbuNjbSxJQ5QDVw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Turner <mattst88@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Helge Deller <deller@gmx.de>, LKML <linux-kernel@vger.kernel.org>, "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>, Michael Kerrisk <mtk.manpages@googlemail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, 5 Feb 2017, Matt Turner wrote:

> > I don't think it is other than for PPC.  If you're not variable endian
> > (which is only PPC to date), then you should know a priori what endian
> > you are from the #defines in userspace.
> 
> MIPS as well, but it seems strange to require the kernel to tell you
> your endianness, when you can easily determine it yourself. Unless
> there's something about this I don't understand.

 Many MIPS processors do have a reverse-endian control bit, which allows a 
user process to execute in the endianness opposite to the endianness the 
kernel runs in.  The feature has been around since 1991 and the R4000 CPU, 
however support is unlikely to be ever added to the MIPS/Linux port, due 
to the complexity required for byte-swapping all the data structures 
passed in memory between the kernel and the userland.  Does the PPC/Linux 
port actually implement this swapping?

  Maciej
