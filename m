From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v7] Add udmabuf misc device
Date: Tue, 11 Sep 2018 12:05:55 +0200
Message-ID: <CAKMK7uFviQPhsehfps0=gyA=bT72uQn1avzN7RXWE-OyRdb9aQ@mail.gmail.com>
References: <20180827093444.23623-1-kraxel@redhat.com> <21053714.0Xa7F2u2PE@avalon>
 <20180911065014.vo6qp6hkb7cjftdc@sirius.home.kraxel.org> <18750721.r4B5nx0M26@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18750721.r4B5nx0M26@avalon>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, dri-devel <dri-devel@lists.freedesktop.org>, David Airlie <airlied@linux.ie>, Tomeu Vizoso <tomeu.vizoso@collabora.com>, Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>, Shuah Khan <shuah@kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:DMA BUFFER SHARING FRAMEWORK" <linux-media@vger.kernel.org>, "moderated list:DMA BUFFER SHARING FRAMEWORK" <linaro-mm-sig@lists.linaro.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 11, 2018 at 11:50 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Gerd,
>
> On Tuesday, 11 September 2018 09:50:14 EEST Gerd Hoffmann wrote:
>>   Hi,
>>
>> >> +#define UDMABUF_CREATE       _IOW('u', 0x42, struct udmabuf_create)
>> >
>> > Why do you start at 0x42 if you reserve the 0x40-0x4f range ?
>>
>> No particular strong reason, just that using 42 was less boring than
>> starting with 0x40.
>>
>> >> +#define UDMABUF_CREATE_LIST  _IOW('u', 0x43, struct
>> >> udmabuf_create_list)
>> >
>> > Where's the documentation ? :-)
>>
>> Isn't it simple enough?
>
> No kernel UAPI is simple enough to get away without documenting it.

Simplest option would be to throw a bit of kerneldoc into the uapi
header, add Documentation/driver-api/dma-buf.rst.
-Daniel

>
>> But, well, yes, I guess I can add some kerneldoc comments.
>>
>> >> +static int udmabuf_vm_fault(struct vm_fault *vmf)
>> >> +{
>> >> +  struct vm_area_struct *vma = vmf->vma;
>> >> +  struct udmabuf *ubuf = vma->vm_private_data;
>> >> +
>> >> +  if (WARN_ON(vmf->pgoff >= ubuf->pagecount))
>> >> +          return VM_FAULT_SIGBUS;
>> >
>> > Just curious, when do you expect this to happen ?
>>
>> It should not.  If it actually happens it would be a bug somewhere,
>> thats why the WARN_ON.
>
> But you seem to consider that this condition that should never happen still
> has a high enough chance of happening that it's worth a WARN_ON(). I was
> wondering why this one in particular, and not other conditions that also can't
> happen and are not checked through the code.
>
>> >> +  struct udmabuf *ubuf;
>> >>
>> >> +  ubuf = kzalloc(sizeof(struct udmabuf), GFP_KERNEL);
>> >
>> > sizeof(*ubuf)
>>
>> Why?  Should not make a difference ...
>
> Because the day we replace
>
>         struct udmabuf *ubuf;
>
> with
>
>         struct udmabuf_ext *ubuf;
>
> and forget to change the next line, we'll introduce a bug. That's why
> sizeof(variable) is preferred over sizeof(type). Another reason is that I can
> easily see that
>
>         ubuf = kzalloc(sizeof(*ubuf), GFP_KERNEL);
>
> is correct, while using sizeof(type) requires me to go and look up the
> declaration of the variable.
>
>> >> +          memfd = fget(list[i].memfd);
>> >> +          if (!memfd)
>> >> +                  goto err_put_pages;
>> >> +          if (!shmem_mapping(file_inode(memfd)->i_mapping))
>> >> +                  goto err_put_pages;
>> >> +          seals = memfd_fcntl(memfd, F_GET_SEALS, 0);
>> >> +          if (seals == -EINVAL ||
>> >> +              (seals & SEALS_WANTED) != SEALS_WANTED ||
>> >> +              (seals & SEALS_DENIED) != 0)
>> >> +                  goto err_put_pages;
>> >
>> > All these conditions will return -EINVAL. I'm not familiar with the memfd
>> > API, should some error conditions return a different error code to make
>> > them distinguishable by userspace ?
>>
>> Hmm, I guess EBADFD would be reasonable in case the file handle isn't a
>> memfd.  Other suggestions?
>
> I'll let others comment on this as I don't feel qualified to pick proper error
> codes, not being familiar with the memfd API.
>
>> I'll prepare a fixup patch series addressing most of the other
>> review comments.
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
