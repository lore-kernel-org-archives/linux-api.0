From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] sys_read: add a compat_sys_read for 64bit system
Date: Thu, 9 Jun 2016 10:08:51 -0700
Message-ID: <CALCETrXCo3doNCoxLPr5p+SPc1CnnFmFcPWKk0m7M1_WOGJWYw@mail.gmail.com>
References: <575775FA.1080009@huawei.com> <57577F91.5080308@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57577F91.5080308-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhangjian (Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Weidong Wang <wangweidong1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux-Api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 7, 2016 at 7:14 PM, Zhangjian (Bamvor)
<bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> Hi,
>
> On 2016/6/8 9:33, Weidong Wang wrote:
>>
>> Test 32 progress and 64 progress on the 64bit system with
>> this progress:
>>
>> int main(int argc, char **argv)
>> {
>>          int fd = 0;
>>          int i, ret = 0;
>>          char buf[512];
>>          unsigned long count = -1;
>>
>>          fd = open("/tmp", O_RDONLY);
>>          if (fd < -1) {
>>                  printf("Pls check the directory is exist?\n");
>>                  return -1;
>>          }
>>          errno = 0;
>>          ret = read(fd, NULL, count);
>>          printf("Ret is %d errno %d\n", ret, errno);
>>          close(fd);
>>
>>          return 0;
>> }
>>
>> we get the different errno. The 64 progress we get errno is -14 while
>> the 32 progress is -21.

On 64-bit, you get -14 == -EFAULT.  Seems reasonable: you passed a bad pointer.

On 32-bit, you get -21 == -EISDIR.  Also seems reasonable: fd is a directory.

>>
>> The reason is that, the user progress would use a 32bit count, while
>> the sys_read size_t in kernel is 64bit.  When the uesrspace count is
>> -1(0xffffffff), it goes to the sys_read, it would be change to a positive
>> number.

That parameter is size_t, which is unsigned.  It's a positive number
in both cases.

I don't think there's a bug here.
