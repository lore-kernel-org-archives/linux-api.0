From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [v8,09/10] tpm: Initialize TPM and get durations and timeoutsg
Date: Tue, 29 Mar 2016 11:53:14 -0400
Message-ID: <56FAA4EA.1040309@linux.vnet.ibm.com>
References: <1457909680-14085-10-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160322063459.GA9420@intel.com> <56F12466.4090502@linux.vnet.ibm.com>
 <20160329153143.GA15083@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160329153143.GA15083-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/29/2016 11:31 AM, Jarkko Sakkinen wrote:
> On Tue, Mar 22, 2016 at 06:54:30AM -0400, Stefan Berger wrote:
>> On 03/22/2016 02:34 AM, Jarkko Sakkinen wrote:
>>> On Sun, Mar 13, 2016 at 06:54:39PM -0400, Stefan Berger wrote:
>>>> Add the retrieval of TPM 1.2 durations and timeouts. Since this requires
>>>> the startup of the TPM, do this for TPM 1.2 and TPM 2.
>>>>
>>>> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>> CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> CC: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>
>>>> ---
>>>> drivers/char/tpm/tpm_vtpm_proxy.c | 95 +++++++++++++++++++++++++++++++++++----
>>>>   1 file changed, 86 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
>>>> index 2bb2c8c..7fd686b 100644
>>>> --- a/drivers/char/tpm/tpm_vtpm_proxy.c
>>>> +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
>>>> @@ -45,8 +45,11 @@ struct proxy_dev {
>>>>   	size_t req_len;              /* length of queued TPM request */
>>>>   	size_t resp_len;             /* length of queued TPM response */
>>>>   	u8 buffer[TPM_BUFSIZE];      /* request/response buffer */
>>>> +
>>>> +	struct work_struct work;     /* task that retrieves TPM timeouts */
>>>>   };
>>>> +static struct workqueue_struct *workqueue;
>>>>   static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev);
>>>> @@ -67,6 +70,15 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
>>>>   	size_t len;
>>>>   	int sig, rc;
>>>> +	mutex_lock(&proxy_dev->buf_lock);
>>>> +
>>>> +	if (!(proxy_dev->state & STATE_OPENED_FLAG)) {
>>>> +		mutex_unlock(&proxy_dev->buf_lock);
>>>> +		return -EPIPE;
>>>> +	}
>>>> +
>>>> +	mutex_unlock(&proxy_dev->buf_lock);
>>>> +
>>>>   	sig = wait_event_interruptible(proxy_dev->wq, proxy_dev->req_len != 0);
>>>>   	if (sig)
>>>>   		return -EINTR;
>>> What if STATE_OPENED_FLAG is set after mutex_unlock()?
>> This flag is only set when the file descriptor for the server side is
>> created (vtpm_proxy_fops_open()). After that it can only be cleared
>> (vtpm_fops_undo_open()) due to an error condition, which then indicates to
>> the server side that the file descriptor is now unusable. One error
>> condition can for example be the failure by the TPM emulator to respond to
>> the TPM_Startup with a success in the response.
> You take the lock two times and OPENED flag could change in-between.
>
> Why couldn't you put the call after wait_event_* after taking the lock?

Good point. Actually the test for the flag has to go into the 
wait_event_interruptible test (without mutex?!) and we have to look at 
that flag after the wait_event_interruptible again to check whether no 
more requests are coming due to the OPEN flag not being set anymore as 
result of an error condition.

I can post a v9 with that change. However, the dropping of the priv 
field from the vendor struct  in the other patch series, will again 
require changes either here or in that other series.

     Stefan
