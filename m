From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 21:24:40 -0500
Message-ID: <cd4717c4-4950-7513-726d-2e1873aeceb5@redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <20181110192027.GA29892@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181110192027.GA29892@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>, Daniel Colascione <dancol@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 11/10/18 2:20 PM, Greg KH wrote:
> Also, what about the basic work of making sure our uapi header files can
> actually be used untouched by a libc?  That isn't the case these days as
> the bionic maintainers like to keep reminding me.  That might be a good
> thing to do _before_ trying to add new things like syscall wrappers.
I agree completely. There are many steps in the checklist to writing
a new syscall, heck we should probably have a checklist!

Socially the issue is difficult because the various communities only
marginally share the same network of developers, care about different
features, or the same features with different priorities.

That doesn't mean we shouldn't try to integrate better. As was pointed
out, various people from the userspace and toolchain communities are
going to LPC to do just this.

-- 
Cheers,
Carlos.
