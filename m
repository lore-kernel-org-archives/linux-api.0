From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH V38 00/29] security: Add support for locking down the
 kernel
Date: Tue, 13 Aug 2019 08:29:33 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1908130829070.3198@namei.org>
References: <20190808000721.124691-1-matthewgarrett@google.com> <alpine.LRH.2.21.1908101608260.25186@namei.org> <CACdnJusx3N_ZoH4=+tqt85K9J5wmUnC-+bTtG_5qSD_TYu74+A@mail.gmail.com> <alpine.LRH.2.21.1908130339130.14197@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1908130339130.14197@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 13 Aug 2019, James Morris wrote:

> On Mon, 12 Aug 2019, Matthew Garrett wrote:
> 
> > On Fri, Aug 9, 2019 at 11:08 PM James Morris <jmorris@namei.org> wrote:
> > > Please verify and test, as I had to make a few minor fixups for my v5.2
> > > base.
> > 
> > Thanks James - there's a few small fixups required, would you like
> > those as separate patches or should I just send you a fixed copy of
> > the original patchset?
> 
> Given there are a few, an updated copy of the patchset will be best.

Actually, that's a lot of patches to resend, just send updates against my 
next-lockdown branch.

-- 
James Morris
<jmorris@namei.org>
