From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [v8,09/10] tpm: Initialize TPM and get durations and timeouts
Date: Tue, 22 Mar 2016 06:54:30 -0400
Message-ID: <56F12466.4090502@linux.vnet.ibm.com>
References: <1457909680-14085-10-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160322063459.GA9420@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160322063459.GA9420@intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/22/2016 02:34 AM, Jarkko Sakkinen wrote:
> On Sun, Mar 13, 2016 at 06:54:39PM -0400, Stefan Berger wrote:
>> Add the retrieval of TPM 1.2 durations and timeouts. Since this requires
>> the startup of the TPM, do this for TPM 1.2 and TPM 2.
>>
>> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
>> CC: linux-kernel@vger.kernel.org
>> CC: linux-doc@vger.kernel.org
>> CC: linux-api@vger.kernel.org
>>
>> ---
>> drivers/char/tpm/tpm_vtpm_proxy.c | 95 +++++++++++++++++++++++++++++++++++----
>>   1 file changed, 86 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
>> index 2bb2c8c..7fd686b 100644
>> --- a/drivers/char/tpm/tpm_vtpm_proxy.c
>> +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
>> @@ -45,8 +45,11 @@ struct proxy_dev {
>>   	size_t req_len;              /* length of queued TPM request */
>>   	size_t resp_len;             /* length of queued TPM response */
>>   	u8 buffer[TPM_BUFSIZE];      /* request/response buffer */
>> +
>> +	struct work_struct work;     /* task that retrieves TPM timeouts */
>>   };
>>   
>> +static struct workqueue_struct *workqueue;
>>   
>>   static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev);
>>   
>> @@ -67,6 +70,15 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
>>   	size_t len;
>>   	int sig, rc;
>>   
>> +	mutex_lock(&proxy_dev->buf_lock);
>> +
>> +	if (!(proxy_dev->state & STATE_OPENED_FLAG)) {
>> +		mutex_unlock(&proxy_dev->buf_lock);
>> +		return -EPIPE;
>> +	}
>> +
>> +	mutex_unlock(&proxy_dev->buf_lock);
>> +
>>   	sig = wait_event_interruptible(proxy_dev->wq, proxy_dev->req_len != 0);
>>   	if (sig)
>>   		return -EINTR;
> What if STATE_OPENED_FLAG is set after mutex_unlock()?

This flag is only set when the file descriptor for the server side is 
created (vtpm_proxy_fops_open()). After that it can only be cleared 
(vtpm_fops_undo_open()) due to an error condition, which then indicates 
to the server side that the file descriptor is now unusable. One error 
condition can for example be the failure by the TPM emulator to respond 
to the TPM_Startup with a success in the response.


>
> Is there some scenario where STATE_OPENED_FLAG would evaluate false
> at this point?

Yes. The flag is reset in vtpm_fops_undo_open(), which is for example 
called in error conditions detected by the worker thread 
(vtpm_proxy_work()) where the server side for example didn't deliver the 
timeouts and durations or the TPM_Startup() wasn't successful.

>
> Actually I couldn't find a scenario where this check would be needed
> because:
>
> * In vtpm_proxy_work() vtpm_proxy_fops_undo_open() is called after
>    sending TPM commands.
> * vtpm_proxy_delete_device() calls vtpm_proxy_work_stop() as its
>    first statement.
>
> Am I ignoring something?

Does the above explain it? The file descriptor is not closed by any 
failure condition, so it stays around but it becomes 'useless' if the 
work thread detected an error by the TPM emulator.

     Stefan

