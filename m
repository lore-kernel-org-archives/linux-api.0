From: Anton Altaparmakov <anton@tuxera.com>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem
 information [ver #10]
Date: Sat, 28 Jul 2018 00:14:14 +0000
Message-ID: <7C807D58-6B8C-400F-AF67-CD2F38BC0AE4@tuxera.com>
References: <CAG48ez0SdSPkimsk-MW7oSQO-Y64X-LD4JXnuPsZXKuz=y1_Kg@mail.gmail.com>
 <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
 <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
 <21395.1532735340@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21395.1532735340@warthog.procyon.org.uk>
Content-Language: en-US
Content-ID: <752FD3C5BE365846B549589674C7578E@tuxera.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi David,

> On 28 Jul 2018, at 00:49, David Howells <dhowells@redhat.com> wrote:
> Jann Horn <jannh@google.com> wrote:
>>> +static int fsinfo_generic_name_encoding(struct dentry *dentry, char *buf)
>>> +{
>>> +       static const char encoding[] = "utf8";
>>> +
>>> +       if (buf)
>>> +               memcpy(buf, encoding, sizeof(encoding) - 1);
>>> +       return sizeof(encoding) - 1;
>>> +}
>> 
>> Is this meant to be "encoding to be used by userspace" or "encoding of
>> on-disk filenames"?
> 
> The latter.
> 
>> Are there any plans to create filesystems that behave differently?
> 
> isofs, fat, ntfs, cifs for example.
> 
>> If the latter: This is wrong for e.g. a vfat mount that uses a codepage,
>> right?  Should the default in that case not be "I don't know"?
> 
> Quite possibly.  Note that it could also be what you're interpreting it as
> because the codepage got overridden by a mount parameter rather than what's on
> the disk (assuming the medium actually records this).

No, nothing like that is recorded on disk.  That would have been way too helpful!  (-;  The only place Windows records such information is, you may have guessed this: in the registry which of course is local to the computer and unrelated to what removable media is attached...

> One thing I'm confused about is that fat has both a codepage and a charset and
> I'm not sure of the difference.

Oh that is quite simple.  (-:

The codepage is what is used to translate from/to the on-disk DOS 8.3 style names into the kernel's Unicode character representation.  The correct codepage for a particular volume is not stored on disk so it can lead to all sorts of fun if you for example create some names on for example a Japanese Windows on a FAT formatted USB stick and then plug that into a US or European Windows where the default code pages are completely different - all your filenames will appear totally corrupt.  (Note this ONLY affects 8.3 style/DOS/short names or whatever you want to call them.)

The charset on the other hand is what is used to convert strings coming in from/going out to userspace into the kernel's Unicode character representation.

The one nice thing about VFAT (and there aren't many nice things about it!) is that for long names (i.e. not the 8.3 style/DOS/short names), it actually stores on-disk little-endian UTF-16 (since Windows 2000, before that it used little endian UCS-2 - the change was needed to support things like Emojis and some languages that go outside the UCS-2 range of fixed 16-bit unicode).

Hope this clears that up.

Best regards,

	Anton

> David

-- 
Anton Altaparmakov <anton at tuxera.com> (replace at with @)
Lead in File System Development, Tuxera Inc., http://www.tuxera.com/
Linux NTFS maintainer
