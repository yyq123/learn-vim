"Current Year"(
	if(@ismbr(Nov))
		if(inventory > @sum(Dec->Budget->Units))
			"Months of Supply" = 1;
		Endif
	Elseif(@ismbr(Oct))
		if(inventory > @sum(Nov->Budget->Units))
			if(inventory > @sum(Nov->Budget->Units, Dec->Budget->Units))
				"Months of Supply" = 2;
			Else
				"Months of Supply" = 1;
			Endif
		Else
			"Months of Supply" = 0;
		Endif
	Elseif(@ismbr(Sep))
		if(inventory > @sum(Oct->Budget->Units))
			if(inventory > @sum(Oct->Budget->Units, Nov->Budget->Units))
				if(inventory > @sum(Oct->Budget->Units, Nov->Budget->Units, Dec->Budget->Units))
					"Months of Supply" = 3;
				Else
					"Months of Supply" = 2;
				Endif
			Else
				"Months of Supply" = 1;
			Endif
		Else
			"Months of Supply" = 0;
		Endif
	Elseif(@ismbr(Aug))
		if(inventory > @sum(Sep->Budget->Units))
			if(inventory > @sum(Sep->Budget->Units, Oct->Budget->Units))
				if(inventory > @sum(Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units))
					if(inventory > @sum(Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units, Dec->Budget->Units))
						"Months of Supply" = 4;
					Else
						"Months of Supply" = 3;
					Endif
				Else
					"Months of Supply" = 2;
				Endif
			Else
				"Months of Supply" = 1;
			Endif
		Else
			"Months of Supply" = 0;
		Endif
	Elseif(@ismbr(Jul))
		if(inventory > @sum(Aug->Budget->Units))
			if(inventory > @sum(Aug->Budget->Units, Sep->Budget->Units))
				if(inventory > @sum(Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units))
					if(inventory > @sum(Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units))
						if(inventory > @sum(Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units, Dec->Budget->Units))
							"Months of Supply" = 5;
						Else
							"Months of Supply" = 4;
						Endif
					Else
						"Months of Supply" = 3;
					Endif
				Else
					"Months of Supply" = 2;
				Endif
			Else
				"Months of Supply" = 1;
			Endif
		Else
			"Months of Supply" = 0;
		Endif
	Elseif(@ismbr(Jun))
		if(inventory > @sum(Jul->Budget->Units))
			if(inventory > @sum(Jul->Budget->Units, Aug->Budget->Units))
				if(inventory > @sum(Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units))
					if(inventory > @sum(Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units))
						if(inventory > @sum(Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units))
							if(inventory > @sum(Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units, Dec->Budget->Units))
								"Months of Supply" = 6;
							Else
								"Months of Supply" = 5;
							Endif
						Else
							"Months of Supply" = 4;
						Endif
					Else
						"Months of Supply" = 3;
					Endif
				Else
					"Months of Supply" = 2;
				Endif
			Else
				"Months of Supply" = 1;
			Endif
		Else
			"Months of Supply" = 0;
		Endif
	Elseif(@ismbr(May))
		if(inventory > @sum(Jun->Budget->Units))
			if(inventory > @sum(Jun->Budget->Units, Jul->Budget->Units))
				if(inventory > @sum(Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units))
					if(inventory > @sum(Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units))
						if(inventory > @sum(Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units))
							if(inventory > @sum(Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units))
								if(inventory > @sum(Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units, Dec->Budget->Units))
									"Months of Supply" = 7;
								Else
									"Months of Supply" = 6;
								Endif
							Else
								"Months of Supply" = 5;
							Endif
						Else
							"Months of Supply" = 4;
						Endif
					Else
						"Months of Supply" = 3;
					Endif
				Else
					"Months of Supply" = 2;
				Endif
			Else
				"Months of Supply" = 1;
			Endif
		Else
			"Months of Supply" = 0;
		Endif
	Elseif(@ismbr(Apr))
		if(inventory > @sum(May->Budget->Units))
			if(inventory > @sum(May->Budget->Units, Jun->Budget->Units))
				if(inventory > @sum(May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units))
					if(inventory > @sum(May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units))
						if(inventory > @sum(May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units))
							if(inventory > @sum(May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units))
								if(inventory > @sum(May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units))
									if(inventory > @sum(May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units, Dec->Budget->Units))
										"Months of Supply" = 8;
									Else
										"Months of Supply" = 7;
									Endif
								Else
									"Months of Supply" = 6;
								Endif
							Else
								"Months of Supply" = 5;
							Endif
						Else
							"Months of Supply" = 4;
						Endif
					Else
						"Months of Supply" = 3;
					Endif
				Else
					"Months of Supply" = 2;
				Endif
			Else
				"Months of Supply" = 1;
			Endif
		Else
			"Months of Supply" = 0;
		Endif
	Elseif(@ismbr(Mar))
		if(inventory > @sum(Apr->Budget->Units))
			if(inventory > @sum(Apr->Budget->Units, May->Budget->Units))
				if(inventory > @sum(Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units))
					if(inventory > @sum(Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units))
						if(inventory > @sum(Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units))
							if(inventory > @sum(Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units))
								if(inventory > @sum(Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units))
									if(inventory > @sum(Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units))
										if(inventory > @sum(Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units, Dec->Budget->Units))
											"Months of Supply" = 9;
										Else
											"Months of Supply" = 8;
										Endif
									Else
										"Months of Supply" = 7;
									Endif
								Else
									"Months of Supply" = 6;
								Endif
							Else
								"Months of Supply" = 5;
							Endif
						Else
							"Months of Supply" = 4;
						Endif
					Else
						"Months of Supply" = 3;
					Endif
				Else
					"Months of Supply" = 2;
				Endif
			Else
				"Months of Supply" = 1;
			Endif
		Else
			"Months of Supply" = 0;
		Endif
	Elseif(@ismbr(Feb))
		if(inventory > @sum(Mar->Budget->Units))
			if(inventory > @sum(Mar->Budget->Units, Apr->Budget->Units))
				if(inventory > @sum(Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units))
					if(inventory > @sum(Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units))
						if(inventory > @sum(Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units))
							if(inventory > @sum(Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units))
								if(inventory > @sum(Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units))
									if(inventory > @sum(Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units))
										if(inventory > @sum(Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units))
											if(inventory > @sum(Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units, Dec->Budget->Units))
												"Months of Supply" = 10;
											Else
												"Months of Supply" = 9;
											Endif
										Else
											"Months of Supply" = 8;
										Endif
									Else
										"Months of Supply" = 7;
									Endif
								Else
									"Months of Supply" = 6;
								Endif
							Else
								"Months of Supply" = 5;
							Endif
						Else
							"Months of Supply" = 4;
						Endif
					Else
						"Months of Supply" = 3;
					Endif
				Else
					"Months of Supply" = 2;
				Endif
			Else
				"Months of Supply" = 1;
			Endif
		Else
			"Months of Supply" = 0;
		Endif
	Elseif(@ismbr(Jan))
		if(inventory > @sum(Jan->Budget->Units, Feb->Budget->Units))
			if(inventory > @sum(Jan->Budget->Units, Feb->Budget->Units, Mar->Budget->Units))
				if(inventory > @sum(Jan->Budget->Units, Feb->Budget->Units, Mar->Budget->Units, Apr->Budget->Units))
					if(inventory > @sum(Jan->Budget->Units, Feb->Budget->Units, Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units))
						if(inventory > @sum(Jan->Budget->Units, Feb->Budget->Units, Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units))
							if(inventory > @sum(Jan->Budget->Units, Feb->Budget->Units, Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units))
								if(inventory > @sum(Jan->Budget->Units, Feb->Budget->Units, Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units))
									if(inventory > @sum(Jan->Budget->Units, Feb->Budget->Units, Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units))
										if(inventory > @sum(Jan->Budget->Units, Feb->Budget->Units, Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units))
											if(inventory > @sum(Jan->Budget->Units,Feb->Budget->Units, Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units))
												if(inventory > @sum(Jan->Budget->Units,Feb->Budget->Units, Mar->Budget->Units, Apr->Budget->Units, May->Budget->Units, Jun->Budget->Units, Jul->Budget->Units, Aug->Budget->Units, Sep->Budget->Units, Oct->Budget->Units, Nov->Budget->Units, Dec->Budget->Units))
													"Months of Supply" = 11;
												Else
													"Months of Supply" = 10;
												Endif
											Else
												"Months of Supply" = 9;
											Endif
										Else
											"Months of Supply" = 8;
										Endif
									Else
										"Months of Supply" = 7;
									Endif
								Else
									"Months of Supply" = 6;
								Endif
							Else
								"Months of Supply" = 5;
							Endif
						Else
							"Months of Supply" = 4;
						Endif
					Else
						"Months of Supply" = 3;
					Endif
				Else
					"Months of Supply" = 2;
				Endif
			Else
				"Months of Supply" = 1;
			Endif
		Else
			"Months of Supply" = 0;
		Endif
	Endif
);
