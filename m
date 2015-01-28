From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Wed, 28 Jan 2015 11:46:17 +0100
Message-ID: <54C8BDF9.7080802@gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>	<1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>	<54BE5DC8.70706@gmail.com>	<54BE9D08.7010804@zonque.org>	<54BF805B.4000609@gmail.com>	<54BFDAAA.50203@zonque.org>	<54C0CE8A.5080805@gmail.com>	<20150123155402.GB2159@kroah.com>	<54C65267.7090905@gmail.com>	<CAG-2HqUCZjc4Ucc-L21uG6e-di4UcLJAT5mW_-5-c-uqmoJyzA@mail.gmail.com>	<54C66F30.8050108@gmail.com> <CANq1E4TtBhA6Ygu9qMU8xVxbL9q+ZBqnfdU0ceeTTfam9aT+=w@mail.gmail.com> <54C7D0A3.4000900@gmail.com> <54C7D573.7080809@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54C7D573.7080809@zonque.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@gmail.com>
Cc: mtk.manpages@gmail.com, Tom Gundersen <teg@jklm.no>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Djalal Harouni <tixxdz@opendz.org>, Johannes Stezenbach <js@sig21.net>, Theodore T'so <tytso@mit.edu>, christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

Hello Daniel,

On 01/27/2015 07:14 PM, Daniel Mack wrote:
> Hi Michael,
> 
> On 01/27/2015 06:53 PM, Michael Kerrisk (man-pages) wrote:
>> On 01/27/2015 04:23 PM, David Herrmann wrote:
> 
>>> I only expect a handful of users to call the ioctls directly. The
>>> libraries that implement the payload-marshaling, in particular. It's a
>>> similar situation with netlink.
>>
>> Thanks, David, for the clarification. I think it would have been helpful
>> to have that more clearly stated up front, especially as some comments 
>> in this thread, such as the above, could be interpreted to mean quite 
>> the opposite. Can I suggest that some text on this point be added to 
>> kdbus.txt?
> 
> We're currently working on an a set of comprehensive man pages to
> document all the commands in the API, along with every struct, enum etc.
> We do that so that developers are able to actually understand every
> detail of the API, even though most people - as David explained - will
> not use that interface directly in the first place but let one of the
> high-level libraries help them integrate D-Bus functionality into their
> applications.

(I suggest that some text about this text go into the kdbus(7) page.)

> If you want, have a look at the upstream repository for a 	preliminary
> version of the new docs.

That's at https://code.google.com/p/d-bus/ , right? This looks like a 
good direction to go in. Thanks for tackling that.

I hope to take a longer look sometime soon, but a few general conventions
for man-pages that you might want to consider following:

* When listing errors, I think you should change your 
  language/formatting somewhat. Examples here from kdbus.endpoint.7:
   
  (1) The man page says

          RETURN VALUE
               On success, all mentioned ioctl commands return 0.

       Better to write this from a user-space point of view:

          RETURN VALUE
               On success, all mentioned ioctl commands return 0; on 
               error, -1 is returned, and errno is set to indicate 
               the error.

  (2) I would change the wording in the ERRORS sections from
       "may return the following errors"
       to
       "may fail with the following errors"

  (3) When listing the errors, drop the minus signs; that's not 
      what user-space sees. They see a positive value in errno.

  (4) The usual formatting convention for constants, including 
      error constants in man pages is boldface, rather than 
      underline/emphasis.

  (5) Insofar as it's possible, it would be good to make all
      pages format nicely within 80 columns. Some of the literal
      text and ASCII art could, I think, be narrowed.

Thanks,

Michael
-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
