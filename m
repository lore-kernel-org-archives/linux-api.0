From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Revised statx(2) man page for review [and AT_EMPTY_PATH question]
Date: Wed, 26 Apr 2017 21:08:56 +0200
Message-ID: <CAKgNAkjUJv1n8_jQZ35FwPV=JJgT19cN612fiLrbRCp_DDjjpQ@mail.gmail.com>
References: <f3ef2be8-dfa5-e1dd-2315-d787a2a2acc3@gmail.com>
 <14390.1493206508@warthog.procyon.org.uk> <95977e2e-ac02-9960-4ed3-d9b988bed46a@gmail.com>
 <20166.1493219435@warthog.procyon.org.uk>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20166.1493219435-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi David,

On 26 April 2017 at 17:10, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Michael Kerrisk (man-pages) <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> > This indicates what stx_attributes the VFS and filesystem actually sup=
port.
>> >
>> >>                __s32 tv_nsec;   /* Nanoseconds before or since tv_sec=
 */
>> >
>> > If you're going to do Dmitry's suggestion, then this needs to be __u32=
 and you
>> > should remove "before or".
>>
>> I think the question is rather: what is going to be done to the API?
>> Will it be changed as Dmitry suggests?
>
> I've forwarded Dmitry's patch to this effect.

The man page now corresponds.

>> Having two ways to do something is odd, and redundant. Note
>> of the other APIs that provide this functionality do so
>> in both ways, AFAIK. It's not a big problem, but certainly
>> strange. If you settle on having just one, then I'd say
>> choose AT_EMPTY_PATH.
>
> If I choose that, I presume I would have to give EINVAL if the path is NU=
LL or
> anything other than ""?

AFAICS, just set lookup_flags to include LOOKUP_EMPTY and
getname_flags() does the rest. (Essentially, AT_EMPTY_PATH is a safety
catch for an empty path: if the path is nonempty, it is interpreted as
usual, othewise if it is empty, you get ENOENT unless AT_EMPTY_PATH is
also set.

>> Under ERRORS I added:
>>
>> .TP
>> .B EINVAL
>> Reserved flag specified in
>> .IR mask .
>>
>> Okay?
>
> That's fine.

Thanks.

>> >>        It should be noted that  the  kernel  may  return  fields  tha=
t
>> >>        weren't  requested  and  may  fail  to  return fields that wer=
e
>> >>        requested, depending on what the backing  filesystem  supports=
.
>> >
>> > Maybe add "and can be safely ignored" in there somewhere since this se=
ems to
>> > be upsetting people.
>>
>> You say "in there somewhere", but it's not quite clear to me which piece
>> this applies to. Could you propose a wording please.
>
> Can you do footnotes in roff?
>
>         It should be noted that  the  kernel  may  return  fields  that
>         weren't  requested[*]  and  may  fail  to  return fields that wer=
e
>         requested, depending on what the backing  filesystem  supports.
>
>         [*] These can be safely ignored.
>
> Or maybe:
>
>         It should be noted that  the  kernel  may  return  fields  that
>         weren't  requested  and  may  fail  to  return fields that were
>         requested, depending on what the backing  filesystem  supports.
>         Fields that are given values despite being unrequested can just
>         be ignored.

I took the second approach.

>> >>        If a filesystem does not support a field or if it has an unrep=
=E2=80=90
>> >>        resentable value (for instance, a file with  an  exotic  type)=
,
>> >>        then  the  mask bit corresponding to that field will be cleare=
d
>> >>        in stx_mask even if the user asked for it  and  a  dummy  valu=
e
>> >>        will  be  filled in for compatibility purposes if one is avail=
=E2=80=90
>> >>        able (e.g., a dummy UID and GID may be specified to mount unde=
r
>> >>        some circumstances).
>> >
>> > I don't promise a dummy value for any "extended" field other than zero=
.
>>
>> I don't know what you mean to say here. Do you mean some
>> text in the page should change?
>
> The paragraph promises a "dummy value will be filled in for compatibility
> purposes if one is available", but doesn't place any restriction on the f=
ields
> towhich this applies.  This is only true of the basic stat fields; all ot=
her
> fields will be cleared if not set.
>
> Maybe we can just leave this as is.  We're not promising a dummy field wi=
ll
> *always* be emplaced.  We can always say that they're just not available =
for
> extended fields if someone asks.
>
> Maybe the best thing to do is to simply add "and cleared otherwise." to t=
he
> end of the paragraph.

Two points:
* You do realize the text about "dummy values" was your original text?
* Adding "and cleared otherwise" to end of the paragraph doesn't make
sense. I'll leave the text as is, but if you want to propose a more
complete phrasing, let me know.

>> > Should this list either be in alphabetical order or offset-in-struct o=
rder?
>>
>> Probably the same order as the struct.
>
> Sounds good.

Already done.

>> Added. But, what does "no usable value here" mean? (The relationship
>> between stx_attributes_mask and stx_attributes still isn't
>> so clear to me.
>
> It's not so obvious with the bits that are currently defined.  But I have=
 a
> patch that adds Windows attribute bits also (for cifs, ntfs, fat, ...).  =
What
> does it mean, say, if the archive bit is clear?  Does it mean that archiv=
e
> isn't set in the fs or that the fs doesn't support it?
>
> Further, I have plans to add a 'setattrx' syscall that takes a statx stru=
ct
> and calls notify_change() with its contents in the kernel.  If I do that,=
 I
> need to indicate to notify_change() what changes should be effected.  stx=
_mask
> covers most of the fields, but not stx_attributes.  Some of these attribu=
tes
> would be alterable.
>
> Would you prefer it to be reverted for the moment?

To what does "it" refer?

Anyway, I think we do need some better text describing these two
fields and the difference between them. Can you come up with
something?

Cheers,

Michael



--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
