From: Rich Felker <dalias@aerifal.cx>
Subject: Re: [musl] Re: [RFC] Possible new execveat(2) Linux syscall
Date: Mon, 17 Nov 2014 13:30:10 -0500
Message-ID: <20141117183010.GE22465@brightrain.aerifal.cx>
References: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
 <20141116195246.GX22465@brightrain.aerifal.cx>
 <CALCETrWWUyizL8HxZKaYE+xuV5eGi8mQcequT9HPvvac=X-dLg@mail.gmail.com>
 <20141116220859.GY22465@brightrain.aerifal.cx>
 <CALCETrVtN73rTxGXV9Xt+sPOitAWCcyrfUWY_3_tAmd+n6V1gA@mail.gmail.com>
 <20141116233202.GA22465@brightrain.aerifal.cx>
 <CAHse=S8uceX-buoeFoA_Qthsr0TZ-nX7_x_098qqwr5pa_2r-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-54435-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <CAHse=S8uceX-buoeFoA_Qthsr0TZ-nX7_x_098qqwr5pa_2r-w@mail.gmail.com>
To: David Drysdale <drysdale@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, libc-alpha <libc-alpha@sourceware.org>, musl@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 17, 2014 at 03:42:15PM +0000, David Drysdale wrote:
> I'm not familiar with O_EXEC either, I'm afraid, so to be clear -- does
> O_EXEC mean the permission check is explicitly skipped later, at execute
> time?  In other words, if you open(O_EXEC) an executable then remove the
> execute bit from the file, does a subsequent fexecve() still work?

Yes. It's just like how read and write permissions work. If you open a
file for read then remove read permissions, or open it for write then
remove write permissions, the existing permissions to the open file
are not lost. Of course open with O_EXEC/O_SEARCH needs to fail if the
caller does not have +x access to the file/directory at the time of
open.

> If it does, then from an implementation perspective that presumably implies
> the need for a record of the permission check in the struct file (and that
> this property would be inherited by any dup()ed file descriptors).  From a
> security perspective, having a gap between time-of-check and time-of-use
> always sounds worrying...

This record already exists for read and write. All that's needed is
for an extra bit to be added to record exec/search permission.

Rich
