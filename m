From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH-v9 0/3] add support for lazytime mount option
Date: Mon, 2 Feb 2015 16:40:28 +0100
Message-ID: <CAKgNAki1Kttu6j=7qWDW=uMqWPSk0A1EW8r5wTb1fv8FGrngdg@mail.gmail.com>
References: <1422855422-7444-1-git-send-email-tytso@mit.edu>
 <CAHO5Pa0ySnLb_UGUw3deVyZEr8gdzzdeyMP5rXcT1MLOeccLGg@mail.gmail.com> <20150202144833.GB2509@thunk.org>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150202144833.GB2509-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Linux Filesystem Development List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Ted,

On 2 February 2015 at 15:48, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> On Mon, Feb 02, 2015 at 07:03:11AM +0100, Michael Kerrisk wrote:
>> Hi Ted,
>>
>> Since this is an API change, linux-api@ shouls be CCed, Added.
>
> I didn't realize a mount option would be considered an API change.

Well, inasmuch as it's exposed via a system call, sure it is.

> The man page project isn't documenting these things, are they?

Indeed it is. See http://man7.org/linux/man-pages/man2/mount.2.html.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
