From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 18:36:30 -0800
Message-ID: <20181112023630.GA20359@kroah.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <20181110192027.GA29892@kroah.com>
 <cd4717c4-4950-7513-726d-2e1873aeceb5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cd4717c4-4950-7513-726d-2e1873aeceb5@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <carlos@redhat.com>
Cc: Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 11, 2018 at 09:24:40PM -0500, Carlos O'Donell wrote:
> On 11/10/18 2:20 PM, Greg KH wrote:
> > Also, what about the basic work of making sure our uapi header files can
> > actually be used untouched by a libc?  That isn't the case these days as
> > the bionic maintainers like to keep reminding me.  That might be a good
> > thing to do _before_ trying to add new things like syscall wrappers.
> I agree completely. There are many steps in the checklist to writing
> a new syscall, heck we should probably have a checklist!

We should have a checklist.  That's a great idea.  Now to find someone
to write it... :)

I'll try to make it to the plumbers talk, but I think there's a
competing one I am supposed to be at at the same time.

greg k-h
