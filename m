From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Date: Tue, 8 Jul 2014 06:12:55 -0700
Message-ID: <20140708131255.GA25362@infradead.org>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com>
 <CALCETrU=HLmw9n-DxPkFV1xP5wtzQ7-YF3-uao6YiGZODA9kdw@mail.gmail.com>
 <20140630154928.GB10375@google.com>
 <CALCETrWJ-rqDo8OvSZWPUt1806gObNtwVHvC4M6kfQgvd3Eg9w@mail.gmail.com>
 <20140708120702.GB30459@infradead.org>
 <CAD=T17FQEZV+iy91wQAvAdd0PW2tsfjpU7atp-xeatm5sEGz5Q@mail.gmail.com>
 <20140708125138.GA4749@infradead.org>
 <CAD=T17FcSKCkEwGMDtcss0Ye-EwuW4Gd2bmXiVj0YV2JG3xeWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAD=T17FcSKCkEwGMDtcss0Ye-EwuW4Gd2bmXiVj0YV2JG3xeWQ@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Meredydd Luff <meredydd@senatehouse.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@amacapital.net>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 08, 2014 at 02:04:45PM +0100, Meredydd Luff wrote:
> On 8 July 2014 13:51, Christoph Hellwig <hch@infradead.org> wrote:
> > Yeah, it won't work for an explicit directory - I was thinking of
> > working relative to $CWD.
> 
> I think that would sacrifice far too much flexibility. Even without
> Capsicum, it would be worthwhile to be able to wire up a static
> seccomp-bpf filter to enforce constraints such as "you can open files
> under fd#5 for reading, but you can only write to files under fd#6,
> and you can't do any global lookups."

Yeah, I didn't intend to advocate this further after your reply.

