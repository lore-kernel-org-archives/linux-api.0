From: Laura Abbott <labbott@redhat.com>
Subject: Re: [PATCH v5 1/2] staging: ion: simplify ioctl args checking
 function
Date: Mon, 9 Oct 2017 09:45:01 -0700
Message-ID: <21cdb12c-efe5-a7f5-3939-01fa9ff20b56@redhat.com>
References: <1506518409-16887-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506518409-16887-2-git-send-email-benjamin.gaignard@linaro.org>
 <CA+M3ks6XGmgxeDf89CFAP2sxtR8Tksend7bZz1o9EkDkxeyxNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+M3ks6XGmgxeDf89CFAP2sxtR8Tksend7bZz1o9EkDkxeyxNg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve@android.com>, Riley Andrews <riandrews@android.com>, Mark Brown <broonie@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: driverdevel <devel@driverdev.osuosl.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/09/2017 02:21 AM, Benjamin Gaignard wrote:
> 2017-09-27 15:20 GMT+02:00 Benjamin Gaignard <benjamin.gaignard@linaro.org>:
>> Make arguments checking more easy to read.
>>
> 
> Hi Laura,
> 
> Even if we don't have found a solution for the second patch I believe
> this one could be useful.
> May I ask you your point of view on those few lines ?
> 
> Benjamin
> 

Yes, this looks better.

Acked-by: Laura Abbott <labbott@redhat.com>

>> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
>> ---
>>  drivers/staging/android/ion/ion-ioctl.c | 11 +++++------
>>  1 file changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
>> index d9f8b14..e26b786 100644
>> --- a/drivers/staging/android/ion/ion-ioctl.c
>> +++ b/drivers/staging/android/ion/ion-ioctl.c
>> @@ -27,19 +27,18 @@ union ion_ioctl_arg {
>>
>>  static int validate_ioctl_arg(unsigned int cmd, union ion_ioctl_arg *arg)
>>  {
>> -       int ret = 0;
>> -
>>         switch (cmd) {
>>         case ION_IOC_HEAP_QUERY:
>> -               ret = arg->query.reserved0 != 0;
>> -               ret |= arg->query.reserved1 != 0;
>> -               ret |= arg->query.reserved2 != 0;
>> +               if (arg->query.reserved0 ||
>> +                   arg->query.reserved1 ||
>> +                   arg->query.reserved2)
>> +                       return -EINVAL;
>>                 break;
>>         default:
>>                 break;
>>         }
>>
>> -       return ret ? -EINVAL : 0;
>> +       return 0;
>>  }
>>
>>  /* fix up the cases where the ioctl direction bits are incorrect */
>> --
>> 2.7.4
>>
> 
> 
> 
