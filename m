From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [musl] Re: [RFC] Possible new execveat(2) Linux syscall
Date: Fri, 21 Nov 2014 02:10:15 -0800
Message-ID: <20141121101015.GF8866@infradead.org>
References: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
 <20141116195246.GX22465@brightrain.aerifal.cx>
 <CALCETrWWUyizL8HxZKaYE+xuV5eGi8mQcequT9HPvvac=X-dLg@mail.gmail.com>
 <20141116220859.GY22465@brightrain.aerifal.cx>
 <CALCETrVtN73rTxGXV9Xt+sPOitAWCcyrfUWY_3_tAmd+n6V1gA@mail.gmail.com>
 <20141116233202.GA22465@brightrain.aerifal.cx>
 <CAHse=S8uceX-buoeFoA_Qthsr0TZ-nX7_x_098qqwr5pa_2r-w@mail.gmail.com>
 <20141117183010.GE22465@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-54609-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20141117183010.GE22465@brightrain.aerifal.cx>
To: Rich Felker <dalias@aerifal.cx>
Cc: David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@amacapital.net>, libc-alpha <libc-alpha@sourceware.org>, musl@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 17, 2014 at 01:30:10PM -0500, Rich Felker wrote:
> On Mon, Nov 17, 2014 at 03:42:15PM +0000, David Drysdale wrote:
> > I'm not familiar with O_EXEC either, I'm afraid, so to be clear -- does
> > O_EXEC mean the permission check is explicitly skipped later, at execute
> > time?  In other words, if you open(O_EXEC) an executable then remove the
> > execute bit from the file, does a subsequent fexecve() still work?
> 
> Yes. It's just like how read and write permissions work. If you open a
> file for read then remove read permissions, or open it for write then
> remove write permissions, the existing permissions to the open file
> are not lost. Of course open with O_EXEC/O_SEARCH needs to fail if the
> caller does not have +x access to the file/directory at the time of
> open.

Adding a FMODE_EXEC similar to FMODE_READ/WRITE would be trivial.
