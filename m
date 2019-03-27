From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V31 25/25] debugfs: Disable open() when kernel is locked
 down
Date: Thu, 28 Mar 2019 03:29:47 +0900
Message-ID: <20190327182947.GA9371@kroah.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-26-matthewgarrett@google.com>
 <CALCETrXDF2c2-gnOyNTnEn-uPAZp0AaSB_PB8e2y8jf7zo=Cyg@mail.gmail.com>
 <20190327003057.GA27311@kroah.com>
 <CALCETrVDDf4dj3Md1Nxc5P_NCToXGnAbEO3bGfwgKSfeVmU4Kw@mail.gmail.com>
 <20190327050615.GA548@kroah.com>
 <16124107-70D3-4CA0-9766-36FC6DC10128@amacapital.net>
 <20190327053342.GA17484@kroah.com>
 <CALCETrUW=r=xyr4pGiGnn9zUEevf=z6PP3111Ds6qguV5SjYUQ@mail.gmail.com>
 <CACdnJus=zXgmNas+XVkWfe+ohAHEGMYLtfuYe0TH-eE=4p0oRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJus=zXgmNas+XVkWfe+ohAHEGMYLtfuYe0TH-eE=4p0oRw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 27, 2019 at 10:42:18AM -0700, Matthew Garrett wrote:
> On Wed, Mar 27, 2019 at 10:40 AM Andy Lutomirski <luto@kernel.org> wrote:
> > As far as I'm concerned, preventing root from crashing the system
> > should not be a design goal of lockdown at all.  And I think that the
> > "integrity" mode should be as non-annoying as possible, so I think we
> > should allow reading from debugfs.
> 
> I have no horse in this game - I'm happy to bring back the previous
> approach for integrity mode and block reads entirely in
> confidentiality mode, but I'd rather not spend another release cycle
> arguing about it.

I really do not care either way about any of this :)

greg k-h
