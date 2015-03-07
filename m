From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 1/6] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Sat, 7 Mar 2015 15:00:35 +0000
Message-ID: <20150307150035.GN28806@sirena.org.uk>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1425548741-12930-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="lBqJz4CGKwlWe7/k"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425548741-12930-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, andrew-g2DYL2Zd6BY@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--lBqJz4CGKwlWe7/k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 05, 2015 at 09:45:41AM +0000, Srinivas Kandagatla wrote:

> +
> +	return eeprom;
> +}
> +EXPORT_SYMBOL(eeprom_register);

This framework uses regmap but regmap is EXPORT_SYMBOL_GPL() and this is
using EXPORT_SYMBOL().

> +int eeprom_unregister(struct eeprom_device *eeprom)
> +{
> +	mutex_lock(&eeprom_mutex);
> +	if (atomic_read(&eeprom->users)) {
> +		mutex_unlock(&eeprom_mutex);

Atomic reads and a mutex - isn't the mutex enough?  Atomics are
generally a recipie for bugs due to the complexity in using them.

--lBqJz4CGKwlWe7/k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJU+xKSAAoJECTWi3JdVIfQ6DEIAIM/ex0gXG8abz8ogrpOMyNU
w14kC3I/qjRowxq6Mm/Ky9YuYzNtUupHSQjmXNyDKZDLQ8DrEvsPh4I2iE1bPm79
1NRA3gUdkR8xEZF+0M66iVIJWrc0M5ko6rZs0AbvzdP0QPLVREJgJsnQ/IwTr/ld
CdzD6eWVfJsJF+/RkFEemV0aPN3KVVhniN6hCaur5MNDxpq1T/iLYuLUrE7u4N+P
adURgU82o7VrDLZRiM25S4LMsDqQf8sGcA8YByPoMPJiF0JzA2fx7dHYGILGqaqS
3NQIWqtdmVlpPHlSO6ExjPmROHKkRvbD+VndlKaNZFfnzNdn5XohplKZTzRfrdY=
=B3YU
-----END PGP SIGNATURE-----

--lBqJz4CGKwlWe7/k--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
