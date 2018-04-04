From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 4 Apr 2018 09:34:11 -0400
Message-ID: <20180404133411.GC16242@thunk.org>
References: <CACdnJuv-VpdhjEe1cMysdHb6Oy67jQqg-_TVHbUrOfH9GmCVvg@mail.gmail.com>
 <CA+55aFwvuoSHhKnn82VnDndZ6oXMJgwHF604gZ=h3ehHyC600A@mail.gmail.com>
 <CA+55aFzJ2sQR13T+20MKEJ5co-f3Ev8rRxQkRCWVaeDSUU3yhQ@mail.gmail.com>
 <CACdnJuti5Riqoi1sesqPALYHq9LT87o4MFj-0Y5BZqqzJ5579g@mail.gmail.com>
 <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com>
 <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com>
 <CA+55aFxgrh5eeG9MRSEsJtyL5yTe0TehZ=BS2josGJaLxoMMBQ@mail.gmail.com>
 <CACdnJutuBaE3RaDx0KM5vDF9Sinrp=3tG9csrS-H3eU-J7-Utw@mail.gmail.com>
 <20180404125743.GB16242@thunk.org>
 <20180404130233.GA24008@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180404130233.GA24008@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Garrett <mjg59@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 04, 2018 at 03:02:33PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 04, 2018 at 08:57:43AM -0400, Theodore Y. Ts'o wrote:
> > On Wed, Apr 04, 2018 at 04:30:18AM +0000, Matthew Garrett wrote:
> > > What I'm afraid of is this turning into a "security" feature that ends up
> > > being circumvented in most scenarios where it's currently deployed - eg,
> > > module signatures are mostly worthless in the non-lockdown case because you
> > > can just grab the sig_enforce symbol address and then kexec a preamble that
> > > flips it back to N regardless of the kernel config.
> > 
> > Whoa.  Why doesn't lockdown prevent kexec?  Put another away, why
> > isn't this a problem for people who are fearful that Linux could be
> > used as part of a Windows boot virus in a Secure UEFI context?
> 
> Because no one is afraid of that :)

Well, this is the excuse used by Windows.  Some more cynical people
believe it's really an anti-competitvie thing, but we should
acknowledge this is what is causing the fear that some distros have
that their UEFI secure boot certs will be revoked by Microsoft if they
don't have this crazy lockdown enforcement for UEFI Secure Boot.

So how about this as a compromise.  We can have a config option for
the behavior that those distros (and Matthew) want, and we can have
separate config options that turn things on in what others would say
is a more rational way.

And I would all be for having the Kconfig description says, "This
config option is only needed by distros who are fearful of Microsoft
revoking their UEFI secure boot certificate."

						- Ted
