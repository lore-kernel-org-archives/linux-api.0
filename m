From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 15:46:31 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1706291545320.1861@nanos>
References: <20170614222017.14653-1-mcgrof@kernel.org> <20170614222017.14653-3-mcgrof@kernel.org> <20170629125402.GH26046@kroah.com> <alpine.DEB.2.20.1706291504570.1861@nanos> <20170629133530.GA14747@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170629133530.GA14747@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, mfuzzey@parkeon.com, ebiederm@xmission.com, dmitry.torokhov@gmail.com, wagi@monom.org, dwmw2@infradead.org, jewalt@lgsinnovations.com, rafal@milecki.pl, arend.vanspriel@broadcom.com, rjw@rjwysocki.net, yi1.li@linux.intel.com, atull@kernel.org, moritz.fischer@ettus.com, pmladek@suse.com, johannes.berg@intel.com, emmanuel.grumbach@intel.com, luciano.coelho@intel.com, kvalo@codeaurora.org, luto@kernel.org, torvalds@linux-foundation.org, keescook@chromium.org, takahiro.akashi@linaro.org, dhowells@redhat.com, pjones@redhat.com, hdegoede@redhat.com, alan@linux.intel.com, tytso@mit.edu, mtk.manpages@gmail.com, paul.gortmaker@windriver.com, mtosatti@redhat.com, mawilcox@microsoft.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 29 Jun 2017, Greg KH wrote:
> On Thu, Jun 29, 2017 at 03:05:26PM +0200, Thomas Gleixner wrote:
> > On Thu, 29 Jun 2017, Greg KH wrote:
> > > On Wed, Jun 14, 2017 at 03:20:15PM -0700, Luis R. Rodriguez wrote:
> > > Do you really still want to add these, now that we know we shouldn't be
> > > using swait in "real" code? :)
> > 
> > And who defined that it should not be used in real code?
> 
> Linus did, in a different firmware thread.  You have to _really_ know
> what you are doing to use this interface, and the firmware interface
> shouldn't be using it.  So adding new apis just for firmware does not
> seem like a wise decision at this point in time.

So it's not about code in general, it's about a particular piece of
code. Fair enough.

Thanks,

	tglx
