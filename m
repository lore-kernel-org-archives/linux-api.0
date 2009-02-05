From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: + preadv-pwritev-add-preadv-and-pwritev-system-calls.patch added
 to -mm tree
Date: Wed, 04 Feb 2009 16:42:48 -0800
Message-ID: <498A3608.3010008@zytor.com>
References: <200902022135.n12LZa1a010673@imap1.linux-foundation.org> <49876A91.4000705@zytor.com> <49881904.30705@redhat.com> <498879B3.8030002@zytor.com> <20090203171559.GA20898@flint.arm.linux.org.uk> <49887EF4.1090300@zytor.com> <20090203174257.GC20898@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20090203174257.GC20898@flint.arm.linux.org.uk>
Sender: linux-arch-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Gerd Hoffmann <kraxel@redhat.com>, akpm@linux-foundation.org, mm-commits@vger.kernel.org, arnd@arndb.de, linux-api@vger.kernel.org, linux-arch@vger.k
List-Id: linux-api@vger.kernel.org

Russell King wrote:
> 
> This is an overly simplified view of things.  There exist syscalls where
> it's not just a matter of padding, but instead where the chosen argument
> order interacts with the ABI padding requirements to produce something
> which the syscall interface can't handle.  There are two solutions to
> that: reorder the syscall arguments or split them up into 32-bit high/low
> quantities.
> 

I just went back and looked specifically at this, and I wonder if you 
could be more concrete.  In particular, this seems to imply a rule 
somewhere which could probably be improved reasonably easily.

	-hpa
