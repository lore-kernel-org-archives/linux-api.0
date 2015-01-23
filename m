From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Sat, 24 Jan 2015 00:08:54 +0800
Message-ID: <20150123160854.GA5210@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com>
 <54BE9D08.7010804@zonque.org>
 <54BF805B.4000609@gmail.com>
 <54BFDAAA.50203@zonque.org>
 <54C0CE8A.5080805@gmail.com>
 <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>
 <54C10DDC.9000503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54C10DDC.9000503@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Daniel Mack <daniel@zonque.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>, Theodore T'so <tytso@mit.edu>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 22, 2015 at 09:49:00AM -0500, Austin S Hemmelgarn wrote:
> While I agree that there should be a way for userspace to get the list of
> supported operations, userspace apps will only actually care about that
> once, when they begin talking to kdbus, because (ignoring the live kernel
> patching that people have been working on recently) the list of supported
> operations isn't going to change while the system is running.  While a u64
> copy has relatively low overhead, it does have overhead, and that is very
> significant when you consider part of the reason some people want kdbus is
> for the performance gain.  Especially for those automotive applications that
> have been mentioned which fire off thousands of messages during start-up,
> every little bit of performance is significant.

A single u64 in a structure is not going to be measurable at all,
processors just copy memory too fast these days for 4 extra bytes to be
noticable.  So let's make this as easy as possible for userspace, making
it simpler logic there, which is much more important than saving
theoretical time in the kernel.

thanks,

greg k-h
