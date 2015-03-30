From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH] stm class: Adding master and channel parameter to ioctl function
Date: Mon, 30 Mar 2015 08:33:13 -0600
Message-ID: <CANLsYkzSMVau2WrWK8Su7eihTnneDyqo03koteduXRM3ZTTz2g@mail.gmail.com>
References: <1427406371-6699-1-git-send-email-mathieu.poirier@linaro.org>
	<878ueed0u3.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878ueed0u3.fsf@ashishki-desk.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, peter.lachner@intel.com, norbert.schulz@intel.com, keven.boell@intel.com, yann.fouassier@intel.com, laurent.fert@intel.com, linux-api@vger.kernel.org, Kaixu Xia <kaixu.xia@linaro.org>, Chunyan Zhang <zhang.chunyan@linaro.org>
List-Id: linux-api@vger.kernel.org

On 30 March 2015 at 08:19, Alexander Shishkin
<alexander.shishkin@linux.intel.com> wrote:
> Mathieu Poirier <mathieu.poirier@linaro.org> writes:
>
>> Hey Alex,
>
> Hi Mathieu,
>
>> Have a look at the following patch and see if you agree with my approach.  If so
>> simply add the code to a third version.
>
> Greg's comment about the two levels of ioctls got me thinking in the
> direction of adding callbacks to stm_data on case-by-case basis and then
> I realized that we might actually move these private callbacks into the
> stm core as well (see my followup to the coresight-stm driver patch).
>
> So, I suggest that we work through the ioctl commands that you need for
> coresight stm and try to see how they fit into the generic scheme of
> things and if we still find that we need implementation-specific ioctl
> commands, then we try to shape them as individual callbacks rather than
> just .ioctl().

Yeah, I'm pretty sure we can come up with something better here.

>
>> diff --git a/include/linux/stm.h b/include/linux/stm.h
>> index 976c94d8f17f..84dd83c47fe7 100644
>> --- a/include/linux/stm.h
>> +++ b/include/linux/stm.h
>> @@ -62,8 +62,9 @@ struct stm_data {
>>                                       unsigned int);
>>       void                    (*unlink)(struct stm_data *, unsigned int,
>>                                         unsigned int);
>> -     long                    (*ioctl)(struct stm_data *, unsigned int,
>> -                                      unsigned long);
>> +     long                    (*ioctl)(struct stm_data *,
>> +                                      unsigned int, unsigned int,
>> +                                      unsigned int, unsigned long);
>
> We might go even further and pass a struct stm_output (which also
> contains number of channels) pointer here, having first moved it from
> drivers/... to include/linux/stm.h, and while at it also do the same to
> the other callbacks that pass master/channel around. Does this make
> sense to you?

Humm...  Do callbacks really need to have access to a struct output?
>From my side of the fence dealing with individual master/channels is
sufficient but other people may have different scenarios.  The end
result is the same and modifying the callback signature doesn't
represent a lot of work.

>
> Regards,
> --
> Alex
