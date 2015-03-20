From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCH v0 01/11] stm class: Introduce an abstraction for System Trace Module devices
Date: Fri, 20 Mar 2015 16:53:50 +0200
Message-ID: <87k2ybd8jl.fsf@ashishki-desk.ger.corp.intel.com>
References: <1425728161-164217-1-git-send-email-alexander.shishkin@linux.intel.com> <1425728161-164217-2-git-send-email-alexander.shishkin@linux.intel.com> <CANLsYkzmnHSbfoWSEWkDx-UTuypALZv42FsZ0XVWz2bfqdGWZQ@mail.gmail.com> <87mw3bewq8.fsf@ashishki-desk.ger.corp.intel.com> <CANLsYkwithjLgtztf8aBDRv-QL2VGOwc4XZ=1sGBSHg4LiymBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANLsYkwithjLgtztf8aBDRv-QL2VGOwc4XZ=1sGBSHg4LiymBg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Pratik Patel <pratikp@codeaurora.org>, peter.lachner@intel.com, norbert.schulz@intel.com, keven.boell@intel.com, yann.fouassier@intel.com, laurent.fert@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Mathieu Poirier <mathieu.poirier@linaro.org> writes:

> As promised I worked on a prototype that connects the coresight-stm
> driver with the generic STM interface you have suggested.  Things work
> quite well and aside from the enhancement related to the ioctl() and
> private member as discussed above, we should move ahead with this.
>
> I will send out a new version of the coresight-stm driver as soon as I
> see your patches with those changes.

Actually, instread of a private member I'd simply pass struct stm_data
pointer to the callback (like we do with other callbacks) and the
private data would be in the structure that embeds this struct stm_data,
so that you can get to it using container_of():

struct my_stm {
       struct stm_data	data;
       void		*my_stuff;
       ...
};

...

long my_ioctl(struct stm_data *data, unsigned int cmd, unsigned long
	      arg)
{
        struct my_stm *mine = container_of(data, struct my_stm, data);

...

Would this work for you? I'm otherwise ready to send the second version
of my patchset.

Regards,
--
Alex
