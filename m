From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 4 Apr 2018 15:57:38 +0200
Message-ID: <20180404135738.GA17482@kroah.com>
References: <CA+55aFwvuoSHhKnn82VnDndZ6oXMJgwHF604gZ=h3ehHyC600A@mail.gmail.com>
 <CA+55aFzJ2sQR13T+20MKEJ5co-f3Ev8rRxQkRCWVaeDSUU3yhQ@mail.gmail.com>
 <CACdnJuti5Riqoi1sesqPALYHq9LT87o4MFj-0Y5BZqqzJ5579g@mail.gmail.com>
 <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com>
 <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com>
 <CA+55aFxgrh5eeG9MRSEsJtyL5yTe0TehZ=BS2josGJaLxoMMBQ@mail.gmail.com>
 <CACdnJutuBaE3RaDx0KM5vDF9Sinrp=3tG9csrS-H3eU-J7-Utw@mail.gmail.com>
 <20180404125743.GB16242@thunk.org>
 <20180404130233.GA24008@kroah.com>
 <20180404133411.GC16242@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180404133411.GC16242@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Matthew Garrett <mjg59@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 04, 2018 at 09:34:11AM -0400, Theodore Y. Ts'o wrote:
> On Wed, Apr 04, 2018 at 03:02:33PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Apr 04, 2018 at 08:57:43AM -0400, Theodore Y. Ts'o wrote:
> > > On Wed, Apr 04, 2018 at 04:30:18AM +0000, Matthew Garrett wrote:
> > > > What I'm afraid of is this turning into a "security" feature that ends up
> > > > being circumvented in most scenarios where it's currently deployed - eg,
> > > > module signatures are mostly worthless in the non-lockdown case because you
> > > > can just grab the sig_enforce symbol address and then kexec a preamble that
> > > > flips it back to N regardless of the kernel config.
> > > 
> > > Whoa.  Why doesn't lockdown prevent kexec?  Put another away, why
> > > isn't this a problem for people who are fearful that Linux could be
> > > used as part of a Windows boot virus in a Secure UEFI context?
> > 
> > Because no one is afraid of that :)
> 
> Well, this is the excuse used by Windows.

Really?  Every time I have tried to actually follow up on this
statement, it turns into an urban myth.  If you have proof of this,
please let me know, otherwise I am going to keep saying it is false.

> Some more cynical people
> believe it's really an anti-competitvie thing, but we should
> acknowledge this is what is causing the fear that some distros have
> that their UEFI secure boot certs will be revoked by Microsoft if they
> don't have this crazy lockdown enforcement for UEFI Secure Boot.

Unsubstantiated fear of relying on another company's signing key to
suddenly stop working is worrying.  But it's just that, fear, and not
anything that is actually true.  We have a working shim binary that is
signed, in use by all distros and other operating systems (community and
corporate).  To revoke that key now would be insane on a variety of
levels.

So let's stop playing the myth and fear card people, and focus on the
actual facts here.

> And I would all be for having the Kconfig description says, "This
> config option is only needed by distros who are fearful of Microsoft
> revoking their UEFI secure boot certificate."

Again, no fear please, facts only.

thanks,

greg k-h
